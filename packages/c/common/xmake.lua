package("common")
    set_homepage("https://github.com/CottonTnT/common")
    set_description("Cross-project reusable C++20 utility library: Noncopyable, Singleton, StringUtil (FNV-1a), InlineBuffer (SBO), XType aliases and memory-size literals.")
    -- 上游仓库暂无 LICENSE 文件，待补充后请在此设置：set_license("...")

    -- 当前实现均为模板 / constexpr 头文件（src/ 预留后续非模板实现），故按纯头文件库安装
    set_kind("library", {headeronly = true})

    -- 以 git 仓库为源（暂无 release tag），版本号指向具体 commit
    add_urls("https://github.com/CottonTnT/common/archive/refs/tags/v$(version).tar.gz")
    add_versions("0.4.0", "7690f003d65315976a8fb8e789f1fd01d6e52bac")

    on_install(function (package)
        os.cp("include/*.hpp", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <InlineBuffer.hpp>
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

                X::InlineBuffer<64> buf;
                buf.append("hello");
                (void)buf.view();
            }
        ]]}, {configs = {languages = "c++20"}}))
    end)

    add_versions("0.5.0", "73f184d8c95f9ade1d852ae0a3c1167e10368b57f5854861abc893f10bbfc14f")
    add_versions("0.6.0", "6bc1fb4f2709d08bbd8ab63b90df4e25a824fca75b45b77cdb06893b4be427e4")
    add_versions("0.6.1", "602139122b3324d947bb0790f1f0dfdd3438757cbeef10f3ef947967f20371e1")
    add_versions("0.6.2", "73bc7c404dd69d324bfa767c355aad1ae8448460b2ce3022ab9a035acd1b9402")
package_end()