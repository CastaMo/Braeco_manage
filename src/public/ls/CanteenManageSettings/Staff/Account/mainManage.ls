page = null
main-manage = let
    
    class Staff
        (name, gender, phone, role) ->
            @name = name
            @gender = gender
            @phone = phone
            @role = role
            
        update-dom: !->
            console.log @name, @gender, @phone, @role
        gene-dom: !->
            console.log @name, @gender, @phone, @role



    initial: !->
        s = new Staff "韦小宝","男","18819481270","管理员"
        s.gene-dom!

module.exports = main-manage