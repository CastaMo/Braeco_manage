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
        secret: grunt.file.readJSON('../secret_for_formal.json'),
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

        copy: {
            test: {
                cwd: '<%= dirs.lib_path %>',
                src: ['<%= dirs.js %>common/*.js'],
                dest: '<%= dirs.dest_path %>',
                expand: true
            },

            backup: {
                cwd: '../braeco_client',
                src: ['**/*', '!./node_modules/*'],
                dest: '../backup/braeco_client',
                expand: true
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
                    "<%= dirs.dest_path %>CanteenManage.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManage/develop.jade"
                }
            },
            manage_dist: {
                files: {
                    "<%= dirs.dist_path %>CanteenManage.php": "<%= dirs.source_path %><%= dirs.jade %>CanteenManage/formal.jade"
                }
            },
            menu_category_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMenu/Category/Category.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Category/develop.jade"
                }
            },
            menu_category_dist: {
                files: {
                    "<%= dirs.dist_path %>CanteenManageMenu/Category/Category.php": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Category/formal.jade"
                }
            },
            menu_food_test: {
                files: {
                    "<%= dirs.dest_path %>CanteenManageMenu/Food/Food.html": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Food/develop.jade"
                }
            },
            menu_food_dist: {
                files: {
                    "<%= dirs.dist_path %>CanteenManageMenu/Food/Food.php": "<%= dirs.source_path %><%= dirs.jade %>CanteenManageMenu/Food/formal.jade"
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
            menu_food_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Food/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Food/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Food/base64.less"
                }
            },
            menu_category_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Category/main.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Category/main.less",
                    "<%= dirs.dest_path %><%= dirs.css %>CanteenManageMenu/Category/base64.css": "<%= dirs.source_path %><%= dirs.less %>CanteenManageMenu/Category/base64.less"
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
            menu_food_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMenu/Food',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food',
                ext: '.js'
            },
            menu_category_test: {
                expand: true,
                cwd: '<%= dirs.source_path %><%= dirs.ls %>CanteenManageMenu/Category',
                src: ['*.ls'],
                dest: '<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Category',
                ext: '.js'
            }

        },
        browserify: {
            manage_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManage/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManage/index.js"]
                }
            },
            menu_food_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Food/index.js"]
                }
            },
            menu_category_test: {
                files: {
                    "<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Category/main.js": ["<%= dirs.dest_path %><%= dirs.js %>CanteenManageMenu/Category/index.js"]
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
            menu_food: {
                options: {
                    livereload: lrPort,
                    debounceDelay: debounceDelay
                },
                files: [
                    '<%= dirs.source_path %>**/CanteenManageMenu/Food/**',
                ],
                tasks: [
                    'less:menu_food_test',
                    'livescript:menu_food_test',
                    'browserify:menu_food_test',
                    'jade:menu_food_test'
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

    grunt.registerTask('default', [
        'express',
        'copy:test',
        'less',
        'livescript',
        'browserify',
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
        'jade',
        'copy:backup',
        'sftp'
    ]);
    grunt.registerTask('backup', [
        'copy:backup',
    ]);
};