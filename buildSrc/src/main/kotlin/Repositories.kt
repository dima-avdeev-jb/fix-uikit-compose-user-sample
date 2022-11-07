import org.gradle.api.artifacts.dsl.RepositoryHandler
import org.gradle.kotlin.dsl.maven

/**
 * JetBrains Compose Dev Maven 仓库
 *
 * @author gavinbaoliu
 * @since 2022/8/5
 */
fun RepositoryHandler.jetbrainsComposeDev() = maven("https://maven.pkg.jetbrains.space/public/p/compose/dev")