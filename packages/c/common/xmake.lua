package("common")
    set_homepage("https://github.com/CottonTnT/common")
    set_description("Cross-project reusable C++20 utility library: Noncopyable, Singleton, StringUtil (FNV-1a), XType aliases and memory-size literals.")
    -- 上游仓库暂无 LICENSE 文件，待补充后请在此设置：set_license("...")

    -- 当前实现均为模板 / constexpr 头文件（src/ 预留后续非模板实现），故按纯头文件库安装
    set_kind("library", {headeronly = true})

    -- 以 git 仓库为源（暂无 release tag），版本号指向具体 commit
    add_urls("https://github.com/CottonTnT/common.git")
    add_versions("2026.10.25", "078bf9cdcde2e0310ecf20cf33e23ce20ab716ab")

    on_install(function (package)
        os.cp("include/*.hpp", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <Singleton.hpp>
            #include <StringUtil.hpp>
            #include <XType.hpp>
            class Counter : public X::Singleton<Counter> {
            public:
                Counter() = default;
                int value_ = 0;
            };
            void test() {
                auto p = Counter::getInstance();
                p->value_ = 1;
                u64 h = X::StringUtil::hashString("common");
                (void)h;
                (void)p;
            }
        ]]}, {configs = {languages = "c++20"}}))
    end)
