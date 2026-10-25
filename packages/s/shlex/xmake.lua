package("shlex")
    set_homepage("https://github.com/CottonTnT/shlex")
    set_description("A modern C++17 POSIX shell-like lexer (split) and joiner, header-only single-file implementation.")
    -- 上游仓库暂无 LICENSE 文件，待补充后请在此设置：set_license("...")

    -- 纯头文件库：显式声明为 headeronly，避免 xmake 在 on_test 时误判缺少链接库
    set_kind("library", {headeronly = true})

    -- 以 git 仓库为源（暂无 release tag），版本号指向具体 commit
    add_urls("https://github.com/CottonTnT/shlex.git")
    add_versions("2026.10.25", "171bc639cdab2b642778f6bac910a169a5abac7f")

    -- 纯头文件库：仅需把 Shlex.hpp 安装到 include 目录
    on_install(function (package)
        os.cp("Shlex.hpp", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <Shlex.hpp>
            #include <string>
            void test() {
                Shlex s;
                s.init("foo bar");
                auto tok = s.next();
                s.appendQuoted("hello world");
                auto joined = s.join();
                (void)tok;
                (void)joined;
            }
        ]]}, {configs = {languages = "c++17"}}))
    end)
