    commit fffabce93a47b5c35cd791b956b37d1ababf914a
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 23:31:28 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 23:31:28 2021 +0200
    
        [#1]: update project version to 0.0.12
    
    commit f0c93f9673c21465cfc90720e6579510899c7461
    Merge: 2644f3c 7a7b751
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 21:29:44 2021 +0000
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 21:29:44 2021 +0000
    
        Merge branch 'feature/8/use_in_production_and_improve' into 'develop'
        
        [#8]: cont migrating BashLib to logging funcs: extend_path almost done;
        
        See merge request DesmoDyne/Tools/BashLib!26
    
    commit 7a7b751bcd27bf1134dd0756eda131a0cd9a40ef
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 23:25:38 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 23:26:01 2021 +0200
    
        [#8]: review/align function log output, adapt tests
    
    commit 6a348bae1e30c408826f25b58b3b8d4c7d446580
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 22:22:24 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 23:26:01 2021 +0200
    
        [#8]: add missing sample code sections to function docs; add TODO
    
    commit 580b5d52e1f76f25fe03f9c51ef292584faf7244
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 22:01:39 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 23:26:01 2021 +0200
    
        [#8]: align formatting in test names to make test output look prettier
    
    commit 0f620febe691ba7728187dde805c87f49d7bd77e
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 21:56:05 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 23:26:01 2021 +0200
    
        [#8]: replace _log NOT_SET by log_critical; replace NOT_SET by NOTSET
    
    commit c497e9deefe4cf8b4a68761f209bbcfbb021dd3e
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 21:42:16 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 23:26:01 2021 +0200
    
        [#8]: add remaining missing bats files for quick switch during dev
    
    commit 75e3530c959fbb08e37345806a0702448dd920c2
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 21:41:24 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 21:41:24 2021 +0200
    
        [#8]: align case in usage shell output
    
    commit d5281d0576dcf0aa14f7626ff662508f11af1b0d
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 21:40:47 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 21:40:47 2021 +0200
    
        [#8]: review get_conf_file_arg and its tests as for other funcs before
    
    commit a2e92a40ccc9496921291e8712221e59fb02ed41
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 21:11:28 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 21:34:45 2021 +0200
    
        [#8]: review usage and its tests; do this first as used by other funcs
    
    commit 23e69ccede51b4dc016497be500d07b19ec3173e
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 19:56:31 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 20:00:03 2021 +0200
    
        [#8]: replace some more printfs by log funcs; add TODOs and comments
    
    commit c3dda5e950d84ce0f9fb131602fadb55d14fb98c
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 15:45:18 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 15:45:51 2021 +0200
    
        [#8]: duplicate tests into regular / elevated logging level as before
    
    commit a85b686583893ca4dd769a99e4c61d7129889846
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 15:45:04 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 15:45:51 2021 +0200
    
        [#8]: replace echo by BashLib logging funcs in get_attrs_from_yaml_file
    
    commit 59ed9708ffffd0e2d5d0639246937e270aa54a22
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 15:14:12 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 15:45:51 2021 +0200
    
        [#8]: duplicate tests into regular / elevated logging level as before
    
    commit d5910f83fdda7b8f5749c0d56923b88fa42190ef
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 15:13:15 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 15:13:15 2021 +0200
    
        [#8]: replace echo by BashLib logging functions in get_attrs_from_json
    
    commit 52b4434ec99ee34ba8f69e2ec4b79436bfba3855
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 15:10:16 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 15:10:16 2021 +0200
    
        [#8]: replace log_critical by log_error; align to using msg with OK/FAIL
    
    commit 8a27307f2bf3cd2d8fe36288a6a6d1fc70191d0a
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 13:34:11 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 13:34:11 2021 +0200
    
        [#8]: bring remaining tests back in on original echo output: see 2d60330
    
    commit 9770e53fab85a3e9acc6cdfc96d2bae2ac0e681c
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 13:11:42 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 13:32:36 2021 +0200
    
        [#8]: begin to bring tests back in on original echo output: see 2d60330
    
    commit c2bf42e0952af3416147ee055a5f2d0e086d1f2e
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 12:49:05 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 12:49:05 2021 +0200
    
        [#8]: begin to re-add tests with elev log level; fix hidden test bugs
    
    commit c273fa107ec41cffd900c2e355904516e40ffed5
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 12:35:49 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 12:38:56 2021 +0200
    
        [#8]: add test for function output with elevated log level:
        
        use new unit test naming scheme to indicate tests are related
        and to prevent having to rename all subsequent tests
    
    commit 49d24954d39de13d9b268dc1032032c70af3908e
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 12:27:59 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 12:28:38 2021 +0200
    
        [#8]: _log expects at least one argument: the log level; adapt tests
    
    commit c9b8a7abf323d511f168f9fd0699f6bf006079d9
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 12:18:24 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 12:28:38 2021 +0200
    
        [#8]: fix tests run with default log level WARNING
    
    commit b95dc6363c81284c02e1f2e74c04d0a6a8cf2118
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 12:17:51 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 12:28:38 2021 +0200
    
        [#8]: can not concatenate message with different log levels
    
    commit bcf8a6d910e8bce54c1c269643702045479bb4cd
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 12:00:46 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 12:28:38 2021 +0200
    
        [#8]: add some more test module in comments for quicker switching in dev
    
    commit 8c9dfe959e2cbc914ba5b85a978433d652ded917
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 11:59:48 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 11:59:48 2021 +0200
    
        [#8]: add unit test to investigate some issue arising in production code
    
    commit 904edd9c11bff861aba634dada36e56071495bbf
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 11:59:11 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 11:59:11 2021 +0200
    
        [#8]: begin to use improved logging functionality in BashLib prod code
    
    commit 27906a49ec89fec4ca78dfe798079257aba8a07c
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 11:56:54 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 11:56:54 2021 +0200
    
        [#8]: pass all arguments in log_* user / wrapper functions
    
    commit e377b2bafa6979ca57e844a680f2fb35c3547fec
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 11:14:08 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 11:27:17 2021 +0200
    
        [#8]: add tests for logging single integer / float / string value
    
    commit a52e9b7eac270d5c9e946f59ed7c9fe6116ebd50
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 11:12:05 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 11:25:49 2021 +0200
    
        [#8]: begin to implement taking format + args strings as args; add tests
    
    commit 0a4fc5f7ff0b53873964c0bd853abcf0018af959
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 10:06:59 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 10:06:59 2021 +0200
    
        [#8]: add test with newlines in log value
    
    commit c7c7dd10f10f3f07b745a4c8a4e9becb9304b69b
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 4 10:05:40 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 4 10:05:40 2021 +0200
    
        [#8]: simplify code: return early if log level is too low for any output
    
    commit 64080870105682b8daa9fb8e7293779f2673a0b5
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Fri Sep 3 11:54:24 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Fri Sep 3 11:54:24 2021 +0200
    
        [#8]: point out what test results should be; skip test
    
    commit fb68c75d2505ea6ed1dbf0ee99ede752621124d4
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Fri Sep 3 11:48:34 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Fri Sep 3 11:49:19 2021 +0200
    
        [#8]: use %b, not %s to log, remove \n; test/doc bats newline issues
    
    commit 220cf6a583d27bf58080c8dd7a3dfd546c06c983
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Fri Sep 3 10:41:10 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Fri Sep 3 10:41:10 2021 +0200
    
        [#8]: rename do_log to _log to indicate internal-only use
    
    commit 0416d9da1b0b87f49f88ad2586f549b6814a4f23
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Fri Sep 3 10:36:45 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Fri Sep 3 10:36:45 2021 +0200
    
        [#8]: prepend _ to global logging variable to indicate internal-only use
    
    commit 81675efffd823ce5e390abc206ace77822e0b35a
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 17:02:09 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 17:02:09 2021 +0200
    
        [#8]: review printf statements in logging funcs; review failed test log
    
    commit 2d603305f3987a0e3aac5f7232c580cdda39e1b6
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 16:15:52 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 16:15:52 2021 +0200
    
        [#8]: cont migrating BashLib to logging funcs: extend_path almost done;
        
        + one echo still due to be replaced by printf, not currently possible
        + add logging TODOs on two issues as they come up in practice:
           1. make it easier to print format string with values
           2. support not appending newline to replace `echo -n`
    
    commit 33b3d629bc202ace94ddfa271a309eaa86e60ead
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 15:54:40 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 15:54:40 2021 +0200
    
        [#8]: begin to migrate BashLib to logging funcs: configure_platform done
    
    commit 02fcfb5b84ebc68510451ad18fa5056de9733bcd
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 15:47:19 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 15:47:19 2021 +0200
    
        [#8]: replace echo by printf in recent logging functions
    
    commit 7a7793419e73006ce00134f8aeee2d866b4c081a
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 15:36:08 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 15:36:08 2021 +0200
    
        [#8]: get tests to work on Linux: set sed/gsed depending on OS_TYPE
    
    commit 2092973b0598b1b48722cd8da70e352f3c15a609
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 15:00:21 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 15:00:21 2021 +0200
    
        [#8]: add function documentation
    
    commit a8682d8a45b5301bfc77ab5a255f5af42f5ce1ad
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 14:50:27 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:50:27 2021 +0200
    
        [#8]: add some TODOs; can't be bothered with bash bullshit anymore...
    
    commit 1dac8a8e59c63adabbb9d5dda9070aef1734b99d
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 14:46:43 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:47:54 2021 +0200
    
        [#8]: add some end to end test to ensure setting log level is effective
    
    commit 3b6053f835a7a28464c19fd8299b55e60c8a6533
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 14:33:52 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:33:52 2021 +0200
    
        [#8]: implement log_info / log_debug; adapt log_critical into unit tests
    
    commit 968d8ad3245fd6d9d7b848f4fffab4e21866845e
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 14:27:00 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:27:34 2021 +0200
    
        [#8]: sed log_critical impl / unit tests into log_error and log_warning
    
    commit 383f9eb564e79149c0a6c80a4db66fc31d4c17e1
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 14:21:02 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:27:34 2021 +0200
    
        [#8]: implement log_critical; add unit tests
    
    commit 56cd44bab88b6f07a34f1e40b83977069fc0d312
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 13:09:32 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:27:34 2021 +0200
    
        [#8]: implement set_log_level; add unit tests
    
    commit 383edb612129fd9a4d5e4e9a7cebc9d06fd2a9de
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 12:23:30 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:27:34 2021 +0200
    
        [#8]: update inactive dependency from bats to much more recent bats-core
    
    commit 5588d8b1021ad58aa1c4bee5e129796b3a5a02a6
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 12:22:44 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:27:34 2021 +0200
    
        [#8]: align bash options with convention; doc using single test suite
    
    commit 5949fee841cb7396c992ad0408a5e3baf7eb0591
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 12:13:16 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 14:27:34 2021 +0200
    
        [#8]: get logging arrays/hashes to work: bash is just one piece of shit
    
    commit 1a456825791138f1bc5051a1ebf445c63877b7aa
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 09:03:33 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 12:24:25 2021 +0200
    
        [#8]: test if log value is array or hash, print error msg; update tests
    
    commit acbc74ce85ff986f44f74f2185587231e5280eb0
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Thu Sep 2 00:29:23 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 12:24:25 2021 +0200
    
        [#8]: begin to implement some logging functions; add unit tests
    
    commit 6e72fbc6daf104b919530b3ae05090a932762f6f
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Wed Sep 1 17:14:06 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 12:24:25 2021 +0200
    
        [#8]: review shellcheck disable statements, remove unnecessary ones
    
    commit 07c484f2c50d64ea331310e43a8d770d6654cbba
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Wed Sep 1 17:31:39 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 12:24:25 2021 +0200
    
        [#8]: make get_attrs_from_yaml_file opt_args arg optional; update tests
    
    commit b0aa9081f8f75fc2043104062dafc307e393dcc4
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Wed Sep 1 12:30:51 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 12:24:25 2021 +0200
    
        [#8]: make get_attrs_from_json opt_args argument optional; update tests
    
    commit 8ba211bac2c041568f618256d5a05a3c34109379
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Wed Sep 1 11:47:29 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 12:24:25 2021 +0200
    
        [#8]: update to yq version 4; add TODO for update to yq 3 error handling
    
    commit cb64b806a2f6b23d8b28a315c40a5e7ac0b3af8c
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Wed Sep 1 11:43:28 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Thu Sep 2 12:24:25 2021 +0200
    
        [#8]: use smarter grep expression; fix sample code in function usage doc
    
    commit 5bfa948f16355b399092d7b28130bb64a19cf960
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Tue Aug 31 05:40:08 2021 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Tue Aug 31 05:40:08 2021 +0200
    
        [#8]: add cp / gcp to list of GNU / BSD/macOS commands
    
    commit 2644f3c495eb4717a2051900d10a7ec3144acde5
    Merge: 0a4723a ab19650
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sun Jul 5 11:48:13 2020 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sun Jul 5 11:48:13 2020 +0200
    
        Merge tag '0.0.11' into develop
        
        automatically_created_release_tag 0.0.11
