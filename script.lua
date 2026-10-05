local scripts = {
    [93978595733734] = "https://voidedx.vercel.app/api/raw?id=vx_naij5g78",
    [138103330716004] = "https://voidedx.vercel.app/api/raw?id=vx_1vb58f4j",
    [537413528] = "https://voidedx.vercel.app/api/raw?id=vx_k3l87sun",
}

local placeId = game.PlaceId
local url = scripts[placeId]

if not url or url == "" then
    warn("ไม่พบสคริปต์สำหรับ PlaceId:", placeId)
    return
end

local source = game:HttpGet(url)
local fn, err = loadstring(source)

if not fn then
    warn("Compile Error:", err)
    return
end

fn()
