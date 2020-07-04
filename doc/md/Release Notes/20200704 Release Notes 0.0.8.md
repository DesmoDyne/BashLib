    commit 8fa10e42b7c25606f228eaefb8fb70eea35e39a5
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Jul 4 08:54:21 2020 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Jul 4 08:54:21 2020 +0200
    
        [#1]: update project version to 0.0.8
    
    commit b04435488656c4b1ac3924f189663c0ecfde901a
    Merge: 9127af2 a795624
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Jul 4 06:53:04 2020 +0000
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Jul 4 06:53:04 2020 +0000
    
        Merge branch 'feature/8/use_in_production_and_improve' into 'develop'
        
        Feature/8/use in production and improve
        
        See merge request DesmoDyne/Tools/BashLib!22
    
    commit a795624725a1ad2526dd25ae9fdcd27162c7565f
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Jul 4 08:52:11 2020 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Jul 4 08:52:11 2020 +0200
    
        [#8]: fix get_attrs_from_yaml_file unit tests:
        
        newer versions of yq (used internally) no longer fail if given an empty
        yaml input file, need to move test as it now tests for success;
        also, yq error message are now more specific --> update to adapt
    
    commit b92780e13bacd0319e16e12815de7e8ec213b7ae
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sun Jun 28 12:22:32 2020 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sun Jun 28 12:22:32 2020 +0200
    
        [#8]: add get_environment; add global output start/end marker strings
    
    commit 39d0c1258d47a933a319b006ffe75a23a553ae2f
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 28 15:30:31 2019 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 28 15:30:31 2019 +0200
    
        [#8]: add TODO on gitlab CI/CD stages
    
    commit 9127af2c181b9bf65ef8bac97492b57c5feaecd8
    Merge: 0dd1029 7084ea7
    Author:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    AuthorDate: Sat Sep 28 11:02:29 2019 +0200
    Commit:     Stefan Schablowski <stefan.schablowski@desmodyne.com>
    CommitDate: Sat Sep 28 11:02:29 2019 +0200
    
        Merge tag '0.0.7' into develop
        
        automatically_created_release_tag 0.0.7
