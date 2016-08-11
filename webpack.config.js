var webpack = require('webpack');
var path = require('path');
var commonsPlugin = new webpack.optimize.CommonsChunkPlugin('common.js');

module.exports = {
    //插件项
    plugins: [commonsPlugin],
    //页面入口文件配置
    entry: ["./bin/public/js/CanteenManageMenu/Food/Single/index"],
    //入口文件输出配置
    output: {
        path: path.join(__dirname, 'dist'),
        filename: '[name].js',
        chunkFilename: "[id].chunk.js?[hash:8]"
    }
};
