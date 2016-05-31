/*global module:false*/
module.exports = function(grunt) {

    var debounceDelay = 0;

    // LiveReload的默认端口号，你也可以改成你想要的端口号
    var lrPort = 35729;
    // 使用connect-livereload模块，生成一个与LiveReload脚本
    // <script src="http://127.0.0.1:35729/livereload.js?snipver=1" type="text/javascript"></script>
    var lrSnippet = require('connect-livereload')({
        port: lrPort
    });
    // 使用 middleware(中间件)，就必须关闭 LiveReload 的浏览器插件
    var serveStatic = require('serve-static');
    var serveIndex = require('serve-index');
    var md5File = require('md5-file');
    var lrMiddleware = function(connect, options, middlwares) {
        return [
            lrSnippet,
            // 静态文件服务器的路径 原先写法：connect.static(options.base[0])
            serveStatic(options.base[0]),
            // 启用目录浏览(相当于IIS中的目录浏览) 原先写法：connect.directory(options.base[0])
            serveIndex(options.base[0])
        ];
    };

    // Project configuration.
    grunt.initConfig({
        // Metadata.
        pkg: grunt.file.readJSON('package.json'),
        secret: grunt.file.readJSON('../secret.json'),
        dirs: grunt.file.readJSON('dirs.json'),

        banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
            '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
            '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
            '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
            ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
        // Task configuration.
        concat: {
            options: {
                banner: '<%= banner %>',
                stripBanners: true
            },
            dist: {
                src: ['lib/<%= pkg.name %>.js'],
                dest: 'dist/<%= pkg.name %>.js'
            }
        },
        uglify: {
            options: {
                banner: '<%= banner %>'
            },
            dist: {
                src: '<%= concat.dist.dest %>',
                dest: 'dist/<%= pkg.name %>.min.js'
            }
        },
        jshint: {
            options: {
                curly: true,
                eqeqeq: true,
                immed: true,
                latedef: true,
                newcap: true,
                noarg: true,
                sub: true,
                undef: true,
                unused: true,
                boss: true,
                eqnull: true,
                browser: true,
                globals: {}
            },
            gruntfile: {
                src: 'Gruntfile.js'
            },
            lib_test: {
                src: ['lib/**/*.js', 'test/**/*.js']
            }
        },
        qunit: {
            files: ['test/**/*.html']
        },

        express: {
            options: {
                // 服务器端口号
                port: 3000,
                // 服务器地址(可以使用主机名localhost，也能使用IP)
                hostname: 'localhost',
                // 物理路径(默认为. 即根目录) 注：使用'.'或'..'为路径的时，可能会返回403 Forbidden. 此时将该值改为相对路径 如：/grunt/reloard。
                base: '.'
            },
            livereload: {
                options: {
                    middleware: lrMiddleware,
                    livereload: true,
                    script: 'app.js'
                }
            }
        },

        /*清除文件*/
        clean: {
            build: {
                src: ["<%= dirs.dest_path %>"]
            },
            version: {
                src: ["<%= dirs.dest_path %>public/<%= dirs.version %>"]
            }
        },

        copy: {
            test: {
                cwd: '<%= dirs.lib_path %>',
                src: ['<%= dirs.js %>common/*.js', '<%= dirs.css %>common/*.css'],
                dest: '<%= dirs.dest_path %>',
                expand: true
            },

            backup: {
                cwd: '../braeco_client',
                src: ['**/*', '!./node_modules/*'],
                dest: '../backup/braeco_client',
                expand: true
            },

            versioncontrol: {
                options: {
                    process: function(content, srcpath) {

                        var versionPrefix = "/public/version";

                        var commonMap = {
                            utiljs: {
                                reg: /(?:\/public\/js\/)(\S+)(?:\/extra\.min\.js)((\?v=)(\w+))?/g,
                                path: 'bin/public/js/common/extra.min.js',
                                prefix: '/public/js/common/extra.min_',
                                type: '.js'
                            }
                        };

                        var pageMap = {
                            mainCss: {
                                reg: /(?:\/public\/css\/)(\S+)(?:\/main\.min\.css)(?:(?:\?v=)(?:\w+))?/g,
                                path: 'bin/public/css/{page}/main.min.css',
                                prefix: '/public/css/{page}/main.min_',
                                type: ".css"
                            },
                            base64Css: {
                                reg: /(?:\/public\/css\/)(\S+)(?:\/base64\.min\.css)(?:(?:\?v=)(?:\w+))?/g,
                                path: 'bin/public/css/{page}/base64.min.css',
                                prefix: '/public/css/{page}/base64.min_',
                                type: ".css"
                            },
                            mainJs: {
                                reg: /(?:\/public\/js\/)(\S+)(?:\/main\.min\.js)(?:(?:\?v=)(?:\w+))?/g,
                                path: 'bin/public/js/{page}/main.min.js',
                                prefix: '/public/js/{page}/main.min_',
                                type: ".js"
                            },
                        };
                        for (var key in commonMap) {
                            content = content.replace(commonMap[key].reg, versionPrefix + commonMap[key].prefix + md5File(commonMap[key].path).substring(0, 10) + commonMap[key].type);
                        }
                        for (var key in pageMap) {
                            var found = pageMap[key].reg.exec(content);

                            if (!found)
                                continue;

                            var file = pageMap[key].path.replace('{page}', found[1]),
                                fileMd5 = md5File(file).substring(0, 10),
                                prefix = pageMap[key].prefix.replace('{page}', found[1]);
                            type = pageMap[key].type

                            content = content.replace(found[0], versionPrefix + prefix + fileMd5 + type);
                        }
                        return content;
                    }
                },
                files: [{
                    cwd: './bin/module',
                    src: ["**/*.html"],
                    dest: './bin/views',
                    expand: true
                }]
            }
        },

        /*编译jade，源文件路径设为src的根目录，src/jade里面装jade的option部分(比如你把head和script分离出来)，编译后放在bin中*/
        jade: {
            options: {
                data: {
                    debug: false,
                },
                pretty: true
            },
            manage_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManage.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManage/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Config.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManage/formal.jade"
                }
            },
            menu_category_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMenu/Category/Category.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Category/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Menu/Category.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Category/formal.jade"
                }
            },
            menu_food_single_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMenu/Food/Single/Single.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Food/Single/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Menu/Food/Single.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Food/Single/formal.jade"
                }
            },
            menu_food_property_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMenu/Food/Property/Property.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Food/Property/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Menu/Food/Property.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Food/Property/formal.jade"
                }
            },
            market_activity_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMarket/Activity/Activity.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Activity/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Market/Activity.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Activity/formal.jade"
                }
            },
            market_member_level_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMarket/Member/Level/Level.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Member/Level/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Market/Member/Level.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Member/Level/formal.jade"
                }
            },
            market_member_list_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMarket/Member/List/List.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Member/List/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Market/Member/List.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Member/List/formal.jade"
                }
            },
            market_member_recharge_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMarket/Member/Recharge/Recharge.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Member/Recharge/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Market/Member/Recharge.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Member/Recharge/formal.jade"
                }
            },
            market_promotion_single_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMarket/Promotion/Single.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Promotion/Single/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Market/Promotion/Single.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMarket/Promotion/Single/formal.jade"
                }
            },
            business_hallOrder_basic_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageBusiness/HallOrder/Basic/Basic.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageBusiness/HallOrder/Basic/develop.jade",
                    "<%= dirs.dest_path %>module/Manage/Business/HallOrder/Basic.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageBusiness/HallOrder/Basic/formal.jade"
                }
            }
        },
        less: {
            options: {
                compress: false,
                yuicompress: false
            },
            common: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>common/common.css": "<%= dirs.source_path %><%= dirs.less %>common/common.less",
                }
            },
            manage_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManage/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManage/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManage/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManage/base64.less"
                }
            },
            menu_category_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Category/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Category/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Category/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Category/base64.less"
                }
            },
            menu_food_single_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Single/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Food/Single/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Single/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Food/Single/base64.less"
                }
            },
            menu_food_property_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Property/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Food/Property/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Property/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Food/Property/base64.less"
                }
            },
            market_member_level_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Level/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Member/Level/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Level/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Member/Level/base64.less"
                }
            },
            market_member_list_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/List/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Member/List/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/List/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Member/List/base64.less"
                }
            },
            market_member_recharge_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Recharge/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Member/Recharge/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Recharge/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Member/Recharge/base64.less"
                }
            },
            market_activity_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Activity/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Activity/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Activity/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Activity/base64.less"
                }
            },
            market_promotion_single_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Promotion/Single/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Promotion/Single/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Promotion/Single/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMarket/Promotion/Single/base64.less"
                }
            },
            business_hallOrder_basic_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageBusiness/HallOrder/Basic/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageBusiness/HallOrder/Basic/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageBusiness/HallOrder/Basic/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageBusiness/HallOrder/Basic/base64.less"
                }
            }
        },
        livescript: {
            options: {
                bare: true,
                join: true,
                flatten: true
            },
            manage_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManage/',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManage/',
                ext: '.js'
            },
            menu_category_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMenu/Category',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Category',
                ext: '.js'
            },
            menu_food_single_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMenu/Food/Single',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Single',
                ext: '.js'
            },
            menu_food_property_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMenu/Food/Property',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Property',
                ext: '.js'
            },
            market_member_recharge_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMarket/Member/Recharge',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Recharge',
                ext: '.js'
            },
            market_member_level_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMarket/Member/Level',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Level',
                ext: '.js'
            },
            market_member_list_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMarket/Member/List',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/List',
                ext: '.js'
            },
            market_activity_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMarket/Activity',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Activity',
                ext: '.js'
            },
            market_promotion_single_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMarket/Promotion/Single',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Promotion/Single',
                ext: '.js'
            },
            business_hallOrder_basic_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageBusiness/HallOrder/Basic',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageBusiness/HallOrder/Basic',
                ext: '.js'
            }
        },
        browserify: {
            manage_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManage/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManage/index.js"]
                }
            },
            menu_category_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Category/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Category/index.js"]
                }
            },
            menu_food_single_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Single/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Single/index.js"]
                }
            },
            menu_food_property_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Property/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Property/index.js"]
                }
            },
            market_member_recharge_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Recharge/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Recharge/index.js"]
                }
            },
            market_member_level_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Level/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Level/index.js"]
                }
            },
            market_member_list_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/List/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/List/index.js"]
                }
            },
            market_activity_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Activity/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Activity/index.js"]
                }
            },
            market_promotion_single_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Promotion/Single/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Promotion/Single/index.js"]
                }
            },
            market_single_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Activity/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Activity/index.js"]
                }
            },
            business_hallOrder_basic_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageBusiness/HallOrder/Basic/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageBusiness/HallOrder/Basic/index.js"]
                }
            }
        },
        watch: {
            common: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    "<%= dirs.source_path %><%= dirs.less %>common/**.less",
                ],
                tasks: [
                    'less:common'
                ]
            },
            manage: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManage/**',
                ],
                tasks: [
                    'less:manage_test',
                    'livescript:manage_test',
                    'browserify:manage_test',
                    'jade:manage_test'
                ]
            },
            menu_category: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMenu/Category/**',
                ],
                tasks: [
                    'less:menu_category_test',
                    'livescript:menu_category_test',
                    'browserify:menu_category_test',
                    'jade:menu_category_test'
                ]
            },
            menu_food_single: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMenu/Food/Single/**',
                ],
                tasks: [
                    'less:menu_food_single_test',
                    'livescript:menu_food_single_test',
                    'browserify:menu_food_single_test',
                    'jade:menu_food_single_test'
                ]
            },
            menu_food_property: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMenu/Food/Property/**',
                ],
                tasks: [
                    'less:menu_food_property_test',
                    'livescript:menu_food_property_test',
                    'browserify:menu_food_property_test',
                    'jade:menu_food_property_test'
                ]
            },
            market_member_recharge_test: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMarket/Member/Recharge/**',
                ],
                tasks: [
                    'less:market_member_recharge_test',
                    'livescript:market_member_recharge_test',
                    'browserify:market_member_recharge_test',
                    'jade:market_member_recharge_test'
                ]
            },
            market_member_level_test: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMarket/Member/Level/**',
                ],
                tasks: [
                    'less:market_member_level_test',
                    'livescript:market_member_level_test',
                    'browserify:market_member_level_test',
                    'jade:market_member_level_test'
                ]
            },
            market_member_list_test: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMarket/Member/List/**',
                ],
                tasks: [
                    'less:market_member_list_test',
                    'livescript:market_member_list_test',
                    'browserify:market_member_list_test',
                    'jade:market_member_list_test'
                ]
            },
            market_activity_test: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMarket/Activity/**',
                ],
                tasks: [
                    'less:market_activity_test',
                    'livescript:market_activity_test',
                    'browserify:market_activity_test',
                    'jade:market_activity_test'
                ]
            },
            market_promotion_single_test: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMarket/Promotion/Single/**',
                ],
                tasks: [
                    'less:market_promotion_single_test',
                    'livescript:market_promotion_single_test',
                    'browserify:market_promotion_single_test',
                    'jade:market_promotion_single_test'
                ]
            },
            business_hallOrder_basic_test: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageBusiness/HallOrder/Basic/**',
                ],
                tasks: [
                    'less:business_hallOrder_basic_test',
                    'livescript:business_hallOrder_basic_test',
                    'browserify:business_hallOrder_basic_test',
                    'jade:business_hallOrder_basic_test'
                ]
            }
        },

        hashmap: {
            options: {
                // These are default options
                output: '#{= dest}/Manage/hash.json',
                etag: null, // See below([#](#option-etag))
                algorithm: 'md5', // the algorithm to create the hash
                rename: '#{= dirname}/#{= basename}_#{= hash}#{= extname}', // save the original file as what
                keep: true, // should we keep the original file or not
                merge: false, // merge hash results into existing `hash.json` file or override it.
                hashlen: 10, // length for hashsum digest
            },
            map: {
                cwd: '<%= dirs.dest_path %>',
                src: ['<%= dirs.js %>**/main.min.js',
                    '<%= dirs.js %>**/extra.min.js',
                    '<%= dirs.css %>**/*.min.css'
                ],
                dest: '<%= dirs.dest_path %>public/<%= dirs.version %>'
            }
        },

        /*压缩js，把dest_path中的js路径里所有js都压缩为一个main.min.js*/
        uglify: {
            options: {
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
                report: "min"
            },
            dist: {
                files: {
                    '<%= dirs.dest_path %><%= dirs.js %>common/extra.min.js': ['<%= dirs.dest_path %><%= dirs.js %>common/*.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManage/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManage/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageBusiness/HallOrder/Basic/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageBusiness/HallOrder/Basic/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Activity/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Activity/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Recharge/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Recharge/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Level/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/Level/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/List/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Member/List/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Promotion/Single/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageMarket/Promotion/Single/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Category/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Category/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Single/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Single/main.js'],
                    '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Property/main.min.js': ['<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/Property/main.js']
                }
            }
        },

        /*把dest_path中的css路径里所有css都压缩为一个main.min.css*/
        cssmin: {
            options: {
                keepSpecialComments: 0,
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            },
            compress: {
                files: {
                    '<%= dirs.dest_path %><%= dirs.css %>common/extra.min.css': ['<%= dirs.dest_path %><%= dirs.css %>common/*.css', '!<%= dirs.dest_path %><%= dirs.css %>common/*.min.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManage/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManage/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManage/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManage/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageBusiness/HallOrder/Basic/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageBusiness/HallOrder/Basic/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageBusiness/HallOrder/Basic/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageBusiness/HallOrder/Basic/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Activity/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Activity/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Activity/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Activity/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Recharge/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Recharge/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Recharge/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Recharge/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/List/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/List/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/List/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/List/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Level/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Level/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Level/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Member/Level/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Promotion/Single/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Promotion/Single/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Promotion/Single/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMarket/Promotion/Single/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Category/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Category/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Category/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Category/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Single/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Single/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Single/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Single/base64.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Property/main.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Property/main.css'],
                    '<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Property/base64.min.css': ['<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/Property/base64.css']
                }
            }
        },

        sftp: {
            options: {
                host: '<%= secret.host %>',
                username: '<%= secret.username %>',
                password: '<%= secret.password %>',
                showProgress: true,
                srcBasePath: "<%= dirs.dest_path %>",
                port: '<%= secret.port %>',
                createDirectories: true
            },
            module: {
                options: {
                    path: '<%= secret.path %>/application'
                },
                files: {
                    "./": ["<%= dirs.dest_path %>views/**/*.html"]
                }
            },
            config: {
                options: {
                    path: '<%= secret.path %>/application'
                },
                files: {
                    "./": ["<%= dirs.dest_path %>public/<%= dirs.version %>**/main.min*.js",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/extra.min*.js",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/main.min*.css",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/base64.min*.css",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/hash.json"
                    ]
                }
            }
        },

        sshexec: {
            test: {
                command: ['sh -c "cd /srv/www/WeTable; ls"',
                    'sh -c "cd /; ls"'
                ],
                options: {
                    host: '<%= secret.host %>',
                    username: '<%= secret.username %>',
                    password: '<%= secret.password %>'
                }
            }
        }
    });


    // These plugins provide necessary tasks.
    grunt.loadNpmTasks('grunt-contrib-nodeunit');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-browserify');
    grunt.loadNpmTasks('grunt-livescript');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-jade');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-ssh');
    grunt.loadNpmTasks('grunt-hashmap');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-express-server');
    grunt.loadNpmTasks('grunt-filerev');
    grunt.loadNpmTasks('grunt-usemin');

    grunt.registerTask('default', [
        'clean:build',
        'express',
        'copy:test',
        'less',
        'livescript',
        'browserify',
        'jade',
        'watch'
    ]);
    grunt.registerTask('ready', [
        'copy:test',
        'less',
        'livescript',
        'uglify',
        'cssmin',
        'clean:version',
        'hashmap'
    ]);
    grunt.registerTask('upload', [
        'clean',
        'copy:test',
        'less',
        'livescript',
        'browserify',
        'jade',
        'cssmin',
        'uglify',
        'hashmap',
        'copy:versioncontrol',
        'sftp'
    ]);
    grunt.registerTask('backup', [
        'copy:backup',
    ]);
};
