import org.gradle.kotlin.dsl.version
import org.gradle.plugin.use.PluginDependenciesSpec

/**
 * JetBrains Compose 插件
 *
 * @author gavinbaoliu
 * @since 2022/8/8
 */
fun PluginDependenciesSpec.jetbrainsCompose() = id("org.jetbrains.compose") version jetbrainsComposeVersion