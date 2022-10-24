module InsideEmsComputer
using Toolips
using ToolipsSession
using ToolipsMarkdown
using ToolipsDefaults

"""
home(c::Connection) -> _
--------------------
The home function is served as a route inside of your server by default. To
    change this, view the start method below.
"""
function home(c::Connection)
    head_img::Component{:img} = img("header-img", src = "animated.gif",
    width = 300)
    posts_menu::Component{:div} = div("posts-menu", align = "center")
    push!(posts_menu, head_img, br())
    stylesheet::Component{:sheet} = ToolipsDefaults.sheet("postssheet")
    write!(c, stylesheet)
    all_posts::Vector{String} = readdir("posts")
    viewed_content::Component{:div} = div("posts-content")
    style!(posts_menu, "transition" => 1seconds)
    style!(viewed_content, "transition" => 1seconds)
    [begin
            name::String = string(replace(post_name, ".md" => ""))
            newbutt::Component{:button} = button("button-$post_name",
            text = name)
            on(c, newbutt, "click") do cm::ComponentModifier
                post_raw = read("posts/$post_name", String)
                post_md = tmd("$name-tmd", post_raw)
                set_children!(cm, viewed_content, [post_md])
            end
            push!(posts_menu, newbutt)
    end for post_name in all_posts]
    bod = body("blogbod")
    push!(bod, posts_menu, viewed_content)
    write!(c, bod)
end

fourofour = route("404") do c
    write!(c, p("404message", text = "404, not found!"))
end

routes = [route("/", home), fourofour]
extensions = Vector{ServerExtension}([Logger(), Files(), Session(), ])
"""
start(IP::String, PORT::Integer, ) -> ::ToolipsServer
--------------------
The start function starts the WebServer.
"""
function start(IP::String = "127.0.0.1", PORT::Integer = 8000)
     ws = WebServer(IP, PORT, routes = routes, extensions = extensions)
     ws.start(); ws
end
end # - module
