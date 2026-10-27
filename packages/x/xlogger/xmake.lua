package("xlogger")
    set_homepage("https://github.com/CottonTnT/XLogger")
    set_description("A lightweight C++20 logging library: std::format-based message formatting, std::source_location call-site capture, composable {name} format fields, and a pluggable Appender system.")
    -- 上游仓库暂无 LICENSE 文件，待补充后请在此设置：set_license("...")

    -- 静态库（由 srcs/*.cpp 编译，非头文件库）
    set_kind("library")

    -- 以 git 仓库为源（暂无 release tag），版本号指向具体 commit
    add_urls("https://github.com/CottonTnT/XLogger.git")
    add_versions("0.1.0", "6b7f20e53f33622d05dc710d01b5406d2c4b691e")

    -- 依赖同仓库的 common（头文件库，public 向下游传递）；链接 pthread（public）
    add_deps("common")
    add_syslinks("pthread")

    on_install(function (package)
        local configs = {}
        -- 包安装时不构建 tests / examples / tools、关闭 -Werror，并复用 package 系统传入的仓库
        configs.buildTests = false
        configs.buildExamples = false
        configs.buildTools = false
        configs.werror = false
        configs.localrepo = false
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <LogAppender.h>
            #include <Logger.h>
            #include <LoggerFactory.h>
            #include <LogLevel.h>
            #include <memory>
            #include <string>

            void test() {
                auto logger = std::make_shared<X::Logger>("pkg-test");
                logger->setLogLevel(X::LogLevel::INFO);
                logger->setFormatPattern("{date:%H:%M:%S} [{level}] [{logger}] {message}{newline}");
                logger->addAppender(X::LogAppender::makeStdoutAppender());
                logger->info("hello xlogger, answer={}", 42);
                logger->warn("warning: value={}", 7);
                logger->error("something went wrong: code={}", -1);

                auto service = X::LoggerFactory::getLogger("OrderService");
                service->debug("dbg {}", 1);
            }
        ]]}, {configs = {languages = "c++20"}}))
    end)
