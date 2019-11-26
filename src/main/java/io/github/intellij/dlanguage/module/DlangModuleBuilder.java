package io.github.intellij.dlanguage.module;

import com.intellij.execution.BeforeRunTask;
import com.intellij.execution.BeforeRunTaskProvider;
import com.intellij.execution.RunnerAndConfigurationSettings;
import com.intellij.execution.configurations.ConfigurationFactory;
import com.intellij.execution.configurations.ConfigurationType;
import com.intellij.execution.configurations.ModuleBasedConfiguration;
import com.intellij.execution.impl.RunConfigurationBeforeRunProvider;
import com.intellij.execution.impl.RunManagerImpl;
import com.intellij.ide.util.projectWizard.ModuleBuilder;
import com.intellij.ide.util.projectWizard.ModuleWizardStep;
import com.intellij.ide.util.projectWizard.ProjectJdkForModuleStep;
import com.intellij.ide.util.projectWizard.WizardContext;
import com.intellij.openapi.Disposable;
import com.intellij.openapi.module.ModuleType;
import com.intellij.openapi.options.ConfigurationException;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.projectRoots.SdkTypeId;
import com.intellij.openapi.roots.ContentEntry;
import com.intellij.openapi.roots.ModifiableRootModel;
import com.intellij.openapi.util.Pair;
import com.intellij.openapi.util.io.FileUtil;
import com.intellij.openapi.vfs.LocalFileSystem;
import com.intellij.openapi.vfs.VirtualFile;
import io.github.intellij.dlanguage.DlangBundle;
import io.github.intellij.dlanguage.DlangSdkType;
import io.github.intellij.dlanguage.icons.DlangIcons;
import io.github.intellij.dlanguage.run.DlangRunAppConfigurationType;
import io.github.intellij.dlanguage.run.DlangRunDmdConfigurationType;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class DlangModuleBuilder extends ModuleBuilder {

    private static final String DLANG_GROUP_NAME = "D Language";
    private static final String RUN_CONFIG_NAME = "Run D App";
    private static final String COMPILE_CONFIG_NAME = "Compile with DMD";

    private final String myBuilderId;
    private final String myPresentableName;
    private final String myDescription;

    private List<Pair<String, String>> sourcePaths;

    public DlangModuleBuilder() {
        this("DLangDmdApp", DlangBundle.INSTANCE.message("module.title"), DlangBundle.INSTANCE.message("module.description"));
    }

    protected DlangModuleBuilder(final String builderId,
                                 final String presentableName,
                                 final String description) {
        myBuilderId = builderId;
        myPresentableName = presentableName;
        myDescription = description;
    }

    @Override
    public String getBuilderId() {
        return myBuilderId;
    }

    @Override
    public Icon getNodeIcon() {
        return DlangIcons.FILE;
    }

    @Override
    public String getDescription() {
        return myDescription;
    }

    @Override
    public String getPresentableName() {
        return myPresentableName;
    }

    @Override
    public String getGroupName() {
        return DLANG_GROUP_NAME;
    }

    @Override
    public String getParentGroup() {
        return DLANG_GROUP_NAME;
    }

    @Override
    public void setupRootModel(@NotNull final ModifiableRootModel rootModel) throws ConfigurationException {
        if (myJdk != null) {
            rootModel.setSdk(myJdk);
        } else {
            rootModel.inheritSdk();
        }

        final ContentEntry contentEntry = doAddContentEntry(rootModel);
        if (contentEntry != null) {
            for (final Pair<String, String> sourcePath : getSourcePaths()) {
                final String path = sourcePath.first;
                final VirtualFile sourceRoot
                    = LocalFileSystem.getInstance().refreshAndFindFileByPath(FileUtil.toSystemIndependentName(path));
                if (sourceRoot != null) {
                    contentEntry.addSourceFolder(sourceRoot, false, sourcePath.second);
                }
            }
        }

        final Project project = rootModel.getProject();
        final RunManagerImpl runManager = RunManagerImpl.getInstanceImpl(project);

        //Create "Compile with DMD" configuration
        RunnerAndConfigurationSettings runDmdSettings = runManager.findConfigurationByName(COMPILE_CONFIG_NAME);
        if (runDmdSettings == null) {
            final DlangRunDmdConfigurationType configurationType
                = ConfigurationType.CONFIGURATION_TYPE_EP.findExtensionOrFail(DlangRunDmdConfigurationType.class);
            final ConfigurationFactory factory = configurationType.getConfigurationFactories()[0];
            runDmdSettings = runManager.createConfiguration(COMPILE_CONFIG_NAME, factory);
            ((ModuleBasedConfiguration) runDmdSettings.getConfiguration()).setModule(rootModel.getModule());

            runManager.addConfiguration(runDmdSettings, false);
        }

        //Create "Run D App" configuration
        RunnerAndConfigurationSettings runAppSettings = runManager.findConfigurationByName(RUN_CONFIG_NAME);
        if (runAppSettings == null) {
            final DlangRunAppConfigurationType configurationType
                = ConfigurationType.CONFIGURATION_TYPE_EP.findExtensionOrFail(DlangRunAppConfigurationType.class);
            final ConfigurationFactory factory = configurationType.getConfigurationFactories()[0];
            runAppSettings = runManager.createConfiguration(RUN_CONFIG_NAME, factory);
            ((ModuleBasedConfiguration) runAppSettings.getConfiguration()).setModule(rootModel.getModule());

            runManager.addConfiguration(runAppSettings, false);

        }

        //Add dependency to exec "runDmdSettings" before running "runAppSettings".
        //XXX: next code doesn't add BeforeRunTask. I don't know why.
        final BeforeRunTaskProvider provider = RunConfigurationBeforeRunProvider.getProvider(project, RunConfigurationBeforeRunProvider.ID);

        if(provider != null) {
            final BeforeRunTask runDmdTask = provider.createTask(runDmdSettings.getConfiguration());
            final List<BeforeRunTask> beforeRunTasks = new ArrayList<>(1);
            beforeRunTasks.add(runDmdTask);
            runManager.setBeforeRunTasks(runAppSettings.getConfiguration(), beforeRunTasks);
        }
    }

    /* By default sources are located in {WORKING_DIR}/source folder. */
    @NotNull
    public List<Pair<String, String>> getSourcePaths() {
        if (sourcePaths == null) {
            final List<Pair<String, String>> paths = new ArrayList<>();
            @NonNls final String path = getContentEntryPath() + File.separator + "source";
            new File(path).mkdirs();
            paths.add(Pair.create(path, ""));
            sourcePaths = paths;
        }
        return sourcePaths;
    }

    @Override
    public boolean isSuitableSdkType(final SdkTypeId sdkType) {
        return sdkType == DlangSdkType.getInstance();
    }

    @Override
    public ModuleType getModuleType() {
        return DlangModuleType.getInstance();
    }

    @Nullable
    @Override
    public ModuleWizardStep getCustomOptionsStep(WizardContext context, Disposable parentDisposable) {
        // todo: instead of using ProjectJdkForModuleStep, create a new ModuleWizardStep specific to D
        //  in which we can configure a compiler and optionally setup dub (so will no longer need DlangDubModuleBuilder).
        //  instead of the following code there would simply be one line, something like: return new DlangCompilerWizardStep(context, this);

        final DlangModuleBuilder moduleBuilder = this;
        return new ProjectJdkForModuleStep(context, DlangSdkType.getInstance()) {
            public void updateDataModel() {
                super.updateDataModel();
                moduleBuilder.setModuleJdk(getJdk());
            }
        };
    }
}
