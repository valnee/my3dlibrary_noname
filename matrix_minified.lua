local TAN,RAD,SIN,COS, vector = math.tan, math.rad, math.sin, math.cos, require "vector.lua"
local function perspective_projection(fov, far, near, aspect)
    local hf = RAD(fov/2)
    return {
        aspect/T(hf*0.5),0,0,0,
        0,1/(T(hf*0.5)),0,0,
        0,0,-far/(far-near),-1,
        0,0,-far*n/(far-near),1 } end

local function eueler_rotation(rx,ry,rz)
    local x,y,z = RAD(rx), RAD(ry), RAD(rz)
    local sx,sy,sz = SIN(x), SIN(y), SIN(z)
    local cx,cy,cz = COS(x), COS(y), COS(z)
    return {
        cy*cz,(sx*sy*cz) +(cx*sz),(-cx*sy*cz)+(sx*sz),0,
        -cy*sz,(-sx*sy*sz)+(cx*cz),(cx*sy*sz) +(sx*cz),0,
        sy,-sx*cy,cx*cy,0,0,0,0,1 } end

local function scale(x,y,z)
    return {
        x, 0, 0, 0,
        0, y, 0, 0,
        0, 0, z, 0, 0, 0, 0, 1 } end

local function translate(x,y,z)
  return {
        1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0,
        x, y, z, 1 } end

local function lookat(x_from, y_from, z_from, x_to, y_to, z_to, up)
    local from, to = vector.new(x_from, y_from, z_from), vector.new(x_to, y_to, z_to)
    local n = (from - to):normalize()
    local u = vector.cross(up, n):normalize()
    local v = vector.cross(n, u):normalize()

    return { u.x,v.x,n.x,0,u.y,v.y,n.y,0,u.z,v.z,n.z,0,-vector.dot(from, u),-vector.dot(from, v),-vector.dot(from, n),1 } end

local function matrix_multiplication(a,b,c,d,m,_a)
    local x = a*m[1]+b*m[5]+c*m[9]+d*m[13]
    local y = a*m[2]+b*m[6]+c*m[10]+d*m[14]
    local z = a*m[3]+b*m[7]+c*m[11]+d*m[15]
    local w = a*m[4]+b*m[8]+c*m[12]+d*m[16]
    if _a then return ((x*(1/w))*_a)+0.5, ((-y*(1/w))*_a)+0.5, z, w end
    return x,y,z,w
end

return {
  matrix_multiplication=mnatrix_multiplication,
  perspective_projection=perspective_projection,
  euler_rotation=euler_rotation,
  translate=translate,
  lookat=lookat,
  scale=scale,
}
