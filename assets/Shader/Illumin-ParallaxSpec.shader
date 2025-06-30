//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Self-Illumin/Parallax Specular" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
 _Shininess ("Shininess", Range(0.01,1)) = 0.078125
 _Parallax ("Height", Range(0.005,0.08)) = 0.02
 _MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
 _Illum ("Illumin (A)", 2D) = "white" {}
 _BumpMap ("Normalmap", 2D) = "bump" {}
 _ParallaxMap ("Heightmap (A)", 2D) = "black" {}
 _EmissionLM ("Emission (Lightmapper)", Float) = 0
}
SubShader { 
 LOD 600
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "RenderType"="Opaque" }
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [_MainTex_ST]
Vector 24 [_BumpMap_ST]
Vector 25 [_Illum_ST]
"!!ARBvp1.0
# 45 ALU
PARAM c[26] = { { 1 },
		state.matrix.mvp,
		program.local[5..25] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[18];
DP4 R2.y, R0, c[17];
DP4 R2.x, R0, c[16];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[21];
DP4 R3.y, R1, c[20];
DP4 R3.x, R1, c[19];
ADD R2.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R3.xyz, R0.x, c[22];
MOV R1.xyz, vertex.attrib[14];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
ADD result.texcoord[4].xyz, R2, R3;
MOV R0.xyz, c[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[15];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[2].y, R0, R2;
DP3 result.texcoord[3].y, R2, R3;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
DP3 result.texcoord[3].z, vertex.normal, R3;
DP3 result.texcoord[3].x, vertex.attrib[14], R3;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[24].xyxy, c[24];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[25], c[25].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 45 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
Vector 24 [_Illum_ST]
"vs_2_0
; 48 ALU
def c25, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c12.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c25.x
dp4 r2.z, r0, c17
dp4 r2.y, r0, c16
dp4 r2.x, r0, c15
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c20
dp4 r3.y, r1, c19
dp4 r3.x, r1, c18
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c21
add oT4.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
mov r1.w, c25.x
mov r1.xyz, c13
dp4 r4.y, c14, r0
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 oT2.y, r2, r3
dp3 oT3.y, r3, r4
dp3 oT2.z, v2, r2
dp3 oT2.x, r2, v1
dp3 oT3.z, v2, r4
dp3 oT3.x, v1, r4
mad oT0.zw, v3.xyxy, c23.xyxy, c23
mad oT0.xy, v3, c22, c22.zwzw
mad oT1.xy, v3, c24, c24.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 9 [_World2Object]
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
Vector 19 [_Illum_ST]
"!!ARBvp1.0
# 21 ALU
PARAM c[20] = { { 1 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
DP3 result.texcoord[2].y, R0, R1;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[19], c[19].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 21 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
Vector 16 [_BumpMap_ST]
Vector 17 [_Illum_ST]
"vs_2_0
; 22 ALU
def c18, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
mov r0.xyz, c13
mov r0.w, c18.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c12.w, -v0
dp3 oT2.y, r0, r1
dp3 oT2.z, v2, r0
dp3 oT2.x, r0, v1
mad oT0.zw, v3.xyxy, c16.xyxy, c16
mad oT0.xy, v3, c15, c15.zwzw
mad oT1.xy, v3, c17, c17.zwzw
mad oT3.xy, v4, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
Vector 25 [_BumpMap_ST]
Vector 26 [_Illum_ST]
"!!ARBvp1.0
# 50 ALU
PARAM c[27] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[14].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[19];
DP4 R2.y, R0, c[18];
DP4 R2.x, R0, c[17];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[22];
DP4 R3.y, R1, c[21];
DP4 R3.x, R1, c[20];
ADD R2.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R3.xyz, R0.x, c[23];
MOV R1.xyz, vertex.attrib[14];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
ADD result.texcoord[4].xyz, R2, R3;
MOV R0.w, c[0].x;
MOV R0.xyz, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[14].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[16];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[2].y, R0, R2;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[3].y, R2, R3;
DP3 result.texcoord[3].z, vertex.normal, R3;
DP3 result.texcoord[3].x, vertex.attrib[14], R3;
ADD result.texcoord[5].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[25].xyxy, c[25];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[24], c[24].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[26], c[26].zwzw;
END
# 50 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
Vector 25 [_BumpMap_ST]
Vector 26 [_Illum_ST]
"vs_2_0
; 53 ALU
def c27, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c14.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c27.x
dp4 r2.z, r0, c19
dp4 r2.y, r0, c18
dp4 r2.x, r0, c17
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c22
dp4 r3.y, r1, c21
dp4 r3.x, r1, c20
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c23
add oT4.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1.w, c27.x
mov r1.xyz, c15
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c16, r1
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c27.y
mul r1.y, r1, c12.x
dp3 oT2.y, r2, r3
dp3 oT3.y, r3, r4
dp3 oT2.z, v2, r2
dp3 oT2.x, r2, v1
dp3 oT3.z, v2, r4
dp3 oT3.x, v1, r4
mad oT5.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT5.zw, r0
mad oT0.zw, v3.xyxy, c25.xyxy, c25
mad oT0.xy, v3, c24, c24.zwzw
mad oT1.xy, v3, c26, c26.zwzw
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 9 [_World2Object]
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 17 [unity_LightmapST]
Vector 18 [_MainTex_ST]
Vector 19 [_BumpMap_ST]
Vector 20 [_Illum_ST]
"!!ARBvp1.0
# 26 ALU
PARAM c[21] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[15];
MOV R1.w, c[0].x;
DP4 R0.w, vertex.position, c[4];
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[14].w, -vertex.position;
DP3 result.texcoord[2].y, R2, R0;
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[17], c[17].zwzw;
END
# 26 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
Vector 19 [_Illum_ST]
"vs_2_0
; 27 ALU
def c20, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
mov r1.xyz, c15
mov r1.w, c20.x
dp4 r0.w, v0, c3
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
dp3 oT2.y, r2, r0
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c20.y
mul r1.y, r1, c12.x
dp3 oT2.z, v2, r2
dp3 oT2.x, r2, v1
mad oT4.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT4.zw, r0
mad oT0.zw, v3.xyxy, c18.xyxy, c18
mad oT0.xy, v3, c17, c17.zwzw
mad oT1.xy, v3, c19, c19.zwzw
mad oT3.xy, v4, c16, c16.zwzw
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Vector 31 [_MainTex_ST]
Vector 32 [_BumpMap_ST]
Vector 33 [_Illum_ST]
"!!ARBvp1.0
# 76 ALU
PARAM c[34] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..33] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[13].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[17];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[16];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[18];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[19];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[21];
MAD R1.xyz, R0.x, c[20], R1;
MAD R0.xyz, R0.z, c[22], R1;
MAD R1.xyz, R0.w, c[23], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[29];
DP4 R3.y, R0, c[28];
DP4 R3.x, R0, c[27];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
MOV R0.w, c[0].x;
DP4 R2.z, R4, c[26];
DP4 R2.y, R4, c[25];
DP4 R2.x, R4, c[24];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[30];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[4].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0.xyz, c[14];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[15];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[2].y, R0, R2;
DP3 result.texcoord[3].y, R2, R3;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
DP3 result.texcoord[3].z, vertex.normal, R3;
DP3 result.texcoord[3].x, vertex.attrib[14], R3;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[32].xyxy, c[32];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[31], c[31].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[33], c[33].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 76 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Vector 30 [_MainTex_ST]
Vector 31 [_BumpMap_ST]
Vector 32 [_Illum_ST]
"vs_2_0
; 79 ALU
def c33, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c12.w
dp4 r0.x, v0, c5
add r1, -r0.x, c16
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c15
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c33.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c17
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c18
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c33.x
dp4 r2.z, r4, c25
dp4 r2.y, r4, c24
dp4 r2.x, r4, c23
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c33.y
mul r0, r0, r1
mul r1.xyz, r0.y, c20
mad r1.xyz, r0.x, c19, r1
mad r0.xyz, r0.z, c21, r1
mad r1.xyz, r0.w, c22, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c28
dp4 r3.y, r0, c27
dp4 r3.x, r0, c26
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c29
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add oT4.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
mov r1.w, c33.x
mov r1.xyz, c13
dp4 r4.y, c14, r0
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 oT2.y, r2, r3
dp3 oT3.y, r3, r4
dp3 oT2.z, v2, r2
dp3 oT2.x, r2, v1
dp3 oT3.z, v2, r4
dp3 oT3.x, v1, r4
mad oT0.zw, v3.xyxy, c31.xyxy, c31
mad oT0.xy, v3, c30, c30.zwzw
mad oT1.xy, v3, c32, c32.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Vector 32 [_MainTex_ST]
Vector 33 [_BumpMap_ST]
Vector 34 [_Illum_ST]
"!!ARBvp1.0
# 81 ALU
PARAM c[35] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..34] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[14].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[18];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[17];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[19];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[20];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[22];
MAD R1.xyz, R0.x, c[21], R1;
MAD R0.xyz, R0.z, c[23], R1;
MAD R1.xyz, R0.w, c[24], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[30];
DP4 R3.y, R0, c[29];
DP4 R3.x, R0, c[28];
MUL R1.w, R3, R3;
MOV R0.w, c[0].x;
MAD R0.x, R4, R4, -R1.w;
DP4 R2.z, R4, c[27];
DP4 R2.y, R4, c[26];
DP4 R2.x, R4, c[25];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[31];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[4].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0.xyz, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[14].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[16];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[2].y, R0, R2;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].z;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[3].y, R2, R3;
DP3 result.texcoord[3].z, vertex.normal, R3;
DP3 result.texcoord[3].x, vertex.attrib[14], R3;
ADD result.texcoord[5].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[33].xyxy, c[33];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[32], c[32].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[34], c[34].zwzw;
END
# 81 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Vector 32 [_MainTex_ST]
Vector 33 [_BumpMap_ST]
Vector 34 [_Illum_ST]
"vs_2_0
; 84 ALU
def c35, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c14.w
dp4 r0.x, v0, c5
add r1, -r0.x, c18
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c17
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c35.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c19
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c20
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c35.x
dp4 r2.z, r4, c27
dp4 r2.y, r4, c26
dp4 r2.x, r4, c25
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c35.y
mul r0, r0, r1
mul r1.xyz, r0.y, c22
mad r1.xyz, r0.x, c21, r1
mad r0.xyz, r0.z, c23, r1
mad r1.xyz, r0.w, c24, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c30
dp4 r3.y, r0, c29
dp4 r3.x, r0, c28
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c31
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add oT4.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1.w, c35.x
mov r1.xyz, c15
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c16, r1
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c35.z
mul r1.y, r1, c12.x
dp3 oT2.y, r2, r3
dp3 oT3.y, r3, r4
dp3 oT2.z, v2, r2
dp3 oT2.x, r2, v1
dp3 oT3.z, v2, r4
dp3 oT3.x, v1, r4
mad oT5.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT5.zw, r0
mad oT0.zw, v3.xyxy, c33.xyxy, c33
mad oT0.xy, v3, c32, c32.zwzw
mad oT1.xy, v3, c34, c34.zwzw
"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 3 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 47 ALU, 4 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.5, 0.41999999, 2, 1 },
		{ 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[2];
ADD R0.y, R1.z, c[5];
RCP R0.y, R0.y;
MOV R0.x, c[3];
MUL R0.x, R0, c[5];
MAD R0.w, R0, c[3].x, -R0.x;
MUL R1.xy, R1, R0.y;
MAD R0.xy, R0.w, R1, fragment.texcoord[0];
MAD R1.zw, R0.w, R1.xyxy, fragment.texcoord[1].xyxy;
MAD R1.xy, R0.w, R1, fragment.texcoord[0].zwzw;
TEX R2.yw, R1, texture[3], 2D;
TEX R0.w, R1.zwzw, texture[2], 2D;
TEX R1, R0, texture[1], 2D;
MAD R0.xy, R2.wyzw, c[5].z, -c[5].w;
MUL R2.w, R0.y, R0.y;
MOV R2.xyz, fragment.texcoord[3];
MAD R2.w, -R0.x, R0.x, -R2;
MAD R2.xyz, R0.z, fragment.texcoord[2], R2;
ADD R0.z, R2.w, c[5].w;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R2.x, R0, R2;
MOV R2.w, c[6].y;
DP3 R0.x, R0, fragment.texcoord[3];
MUL R2.y, R2.w, c[4].x;
MAX R2.x, R2, c[6];
POW R2.x, R2.x, R2.y;
MUL R3.x, R1.w, R2;
MOV R2, c[1];
MUL R1, R1, c[2];
MAX R3.y, R0.x, c[6].x;
MUL R0.xyz, R1, c[0];
MUL R0.xyz, R0, R3.y;
MUL R2.xyz, R2, c[0];
MAD R0.xyz, R2, R3.x, R0;
MUL R0.xyz, R0, c[5].z;
MAD R0.xyz, R1, fragment.texcoord[4], R0;
MUL R1.xyz, R1, R0.w;
MUL R0.w, R2, c[0];
ADD result.color.xyz, R0, R1;
MAD result.color.w, R3.x, R0, R1;
END
# 47 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 3 [_BumpMap] 2D
"ps_2_0
; 54 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
mov r0.y, t0.w
mov r0.x, t0.z
mov r5.y, t0.w
mov r5.x, t0.z
texld r0, r0, s0
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t2
add r1.x, r3.z, c5.y
rcp r2.x, r1.x
mov_pp r1.x, c5
mul r3.xy, r3, r2.x
mul_pp r1.x, c3, r1
mad_pp r1.x, r0.w, c3, -r1
mad r2.xy, r1.x, r3, t0
mad r4.xy, r1.x, r3, t1
mad r3.xy, r1.x, r3, r5
mov_pp r0.w, c0
texld r1, r4, s2
texld r3, r3, s3
texld r2, r2, s1
mov_pp r4.xyz, t3
mad_pp r4.xyz, r0.x, t2, r4
mov r1.y, r3
mov r1.x, r3.w
mad_pp r3.xy, r1, c5.z, c5.w
mul_pp r1.x, r3.y, r3.y
mad_pp r1.x, -r3, r3, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r4, r4
rsq_pp r0.x, r0.x
rcp_pp r3.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r4
dp3_pp r1.x, r3, r1
mov_pp r0.x, c4
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r4.x, r1.x, r0.x
dp3_pp r1.x, r3, t3
mul_pp r3.x, c1.w, r0.w
mov r0.x, r4.x
mul r0.x, r2.w, r0
mul_pp r2, r2, c2
mad r0.w, r0.x, r3.x, r2
mov_pp r3.xyz, c0
max_pp r1.x, r1, c6.y
mul_pp r4.xyz, r2, c0
mul_pp r1.xyz, r4, r1.x
mul_pp r3.xyz, c1, r3
mad r0.xyz, r3, r0.x, r1
mul r0.xyz, r0, c5.z
mul r1.xyz, r2, r1.w
mad_pp r0.xyz, r2, t4, r0
add_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" }
Vector 0 [_Color]
Float 1 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 4 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 0.5, 0.41999999, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[2];
ADD R0.y, R1.z, c[2];
RCP R0.y, R0.y;
MOV R0.x, c[1];
MUL R0.x, R0, c[2];
MUL R1.xy, R1, R0.y;
MAD R0.x, R0.w, c[1], -R0;
MAD R0.zw, R0.x, R1.xyxy, fragment.texcoord[1].xyxy;
MAD R0.xy, R0.x, R1, fragment.texcoord[0];
TEX R2, R0, texture[1], 2D;
TEX R0.w, R0.zwzw, texture[2], 2D;
TEX R1, fragment.texcoord[3], texture[4], 2D;
MUL R0.xyz, R1.w, R1;
MUL R1, R2, c[0];
MUL R2.xyz, R1, R0.w;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[2].z, R2;
MOV result.color.w, R1;
END
# 21 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" }
Vector 0 [_Color]
Float 1 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 4 [unity_Lightmap] 2D
"ps_2_0
; 20 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s4
def c2, 0.50000000, 0.41999999, 8.00000000, 0
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3.xy
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, t2
add r0.x, r2.z, c2.y
rcp r1.x, r0.x
mov_pp r0.x, c2
mul_pp r0.x, c1, r0
mul r1.xy, r2, r1.x
mad_pp r0.x, r0.w, c1, -r0
mad r2.xy, r0.x, r1, t0
mad r0.xy, r0.x, r1, t1
texld r1, r2, s1
texld r0, r0, s2
texld r2, t3, s4
mul_pp r1, r1, c0
mul_pp r0.xyz, r2.w, r2
mul_pp r0.xyz, r0, r1
mul r1.xyz, r1, r0.w
mov_pp r0.w, r1
mad_pp r0.xyz, r0, c2.z, r1
mov_pp oC0, r0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 3 [_BumpMap] 2D
SetTexture 4 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 50 ALU, 5 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.5, 0.41999999, 2, 1 },
		{ 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.x;
MUL R1.xyz, R0.y, fragment.texcoord[2];
ADD R0.z, R1, c[5].y;
RCP R0.z, R0.z;
MOV R0.x, c[3];
MUL R0.x, R0, c[5];
MUL R1.xy, R1, R0.z;
MAD R0.x, R0.w, c[3], -R0;
MAD R2.xy, R0.x, R1, fragment.texcoord[0].zwzw;
MAD R0.zw, R0.x, R1.xyxy, fragment.texcoord[1].xyxy;
MAD R1.xy, R0.x, R1, fragment.texcoord[0];
TEX R2.yw, R2, texture[3], 2D;
TEX R0.w, R0.zwzw, texture[2], 2D;
TEX R1, R1, texture[1], 2D;
TXP R0.x, fragment.texcoord[5], texture[4], 2D;
MAD R3.xy, R2.wyzw, c[5].z, -c[5].w;
MOV R2.xyz, fragment.texcoord[3];
MUL R0.z, R3.y, R3.y;
MAD R2.xyz, R0.y, fragment.texcoord[2], R2;
MAD R0.y, -R3.x, R3.x, -R0.z;
DP3 R0.z, R2, R2;
RSQ R0.z, R0.z;
ADD R0.y, R0, c[5].w;
RSQ R0.y, R0.y;
RCP R3.z, R0.y;
MUL R2.xyz, R0.z, R2;
DP3 R0.z, R3, R2;
MOV R2, c[1];
MOV R0.y, c[6];
MAX R0.z, R0, c[6].x;
MUL R0.y, R0, c[4].x;
POW R0.y, R0.z, R0.y;
MUL R0.z, R1.w, R0.y;
MUL R2.w, R2, c[0];
MUL R0.y, R0.z, R2.w;
MUL R1, R1, c[2];
DP3 R2.w, R3, fragment.texcoord[3];
MAX R2.w, R2, c[6].x;
MUL R3.xyz, R1, c[0];
MUL R3.xyz, R3, R2.w;
MUL R2.xyz, R2, c[0];
MAD R2.xyz, R2, R0.z, R3;
MUL R2.w, R0.x, c[5].z;
MUL R3.xyz, R1, R0.w;
MUL R2.xyz, R2, R2.w;
MAD R1.xyz, R1, fragment.texcoord[4], R2;
ADD result.color.xyz, R1, R3;
MAD result.color.w, R0.x, R0.y, R1;
END
# 50 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 3 [_BumpMap] 2D
SetTexture 4 [_ShadowMapTexture] 2D
"ps_2_0
; 56 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5
texldp r5, t5, s4
mov_pp r1.x, c5
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c3, r1
mov r2.y, t0.w
texld r0, r0, s0
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mad_pp r1.x, r0.w, c3, -r1
mul_pp r3.xyz, r0.x, t2
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r3.xy, r3, r2.x
mov r2.x, t0.z
mad r2.xy, r1.x, r3, r2
mad r4.xy, r1.x, r3, t1
mad r3.xy, r1.x, r3, t0
mov_pp r0.w, c0
texld r1, r4, s2
texld r2, r2, s3
texld r3, r3, s1
mov_pp r4.xyz, t3
mad_pp r4.xyz, r0.x, t2, r4
mov r1.y, r2
mov r1.x, r2.w
mad_pp r2.xy, r1, c5.z, c5.w
mul_pp r1.x, r2.y, r2.y
mad_pp r1.x, -r2, r2, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r4, r4
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r4
dp3_pp r1.x, r2, r1
mov_pp r0.x, c4
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r4.x, r1.x, r0.x
mov r0.x, r4.x
mul r0.x, r3.w, r0
mul_pp r3, r3, c2
mul_pp r1.x, c1.w, r0.w
mul r1.x, r0, r1
dp3_pp r2.x, r2, t3
mad r0.w, r5.x, r1.x, r3
max_pp r1.x, r2, c6.y
mul_pp r4.xyz, r3, c0
mov_pp r2.xyz, c0
mul_pp r1.xyz, r4, r1.x
mul_pp r2.xyz, c1, r2
mad r1.xyz, r2, r0.x, r1
mul_pp r0.x, r5, c5.z
mul r0.xyz, r1, r0.x
mul r1.xyz, r3, r1.w
mad_pp r0.xyz, r3, t4, r0
add_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" }
Vector 0 [_Color]
Float 1 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 5 TEX
PARAM c[3] = { program.local[0..1],
		{ 0.5, 0.41999999, 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R2, fragment.texcoord[3], texture[5], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[2];
ADD R0.y, R1.z, c[2];
RCP R0.y, R0.y;
MOV R0.x, c[1];
MUL R0.x, R0, c[2];
MUL R1.xy, R1, R0.y;
MAD R0.x, R0.w, c[1], -R0;
MAD R0.zw, R0.x, R1.xyxy, fragment.texcoord[1].xyxy;
MAD R0.xy, R0.x, R1, fragment.texcoord[0];
TEX R1, R0, texture[1], 2D;
TXP R0.x, fragment.texcoord[4], texture[4], 2D;
TEX R0.w, R0.zwzw, texture[2], 2D;
MUL R3.xyz, R2, R0.x;
MUL R1, R1, c[0];
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, c[2].z;
MUL R3.xyz, R3, c[2].w;
MIN R3.xyz, R2, R3;
MUL R0.xyz, R2, R0.x;
MUL R2.xyz, R1, R0.w;
MAX R0.xyz, R3, R0;
MAD result.color.xyz, R1, R0, R2;
MOV result.color.w, R1;
END
# 27 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" }
Vector 0 [_Color]
Float 1 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_2_0
; 25 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s4
dcl_2d s5
def c2, 0.50000000, 0.41999999, 8.00000000, 2.00000000
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3.xy
dcl t4
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, t2
add r0.x, r2.z, c2.y
rcp r1.x, r0.x
mov_pp r0.x, c2
mul_pp r0.x, c1, r0
mul r1.xy, r2, r1.x
mad_pp r0.x, r0.w, c1, -r0
mad r2.xy, r0.x, r1, t1
mad r0.xy, r0.x, r1, t0
texld r3, r2, s2
texld r2, r0, s1
texldp r0, t4, s4
texld r1, t3, s5
mul_pp r3.xyz, r1.w, r1
mul_pp r1.xyz, r1, r0.x
mul_pp r3.xyz, r3, c2.z
mul_pp r1.xyz, r1, c2.w
min_pp r1.xyz, r3, r1
mul_pp r0.xyz, r3, r0.x
max_pp r0.xyz, r1, r0
mul_pp r1, r2, c0
mul r2.xyz, r1, r3.w
mov_pp r0.w, r1
mad_pp r0.xyz, r1, r0, r2
mov_pp oC0, r0
"
}
}
 }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardAdd" "RenderType"="Opaque" }
  ZWrite Off
  Fog {
   Color (0,0,0,0)
  }
  Blend One One
Program "vp" {
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 34 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[19];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[17].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 37 ALU
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c21.x
dp3 oT2.y, r2, r0
dp3 oT2.z, v2, r0
dp3 oT2.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 oT1.y, r1, r2
dp3 oT1.z, v2, r1
dp3 oT1.x, r1, v1
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Vector 12 [_MainTex_ST]
Vector 13 [_BumpMap_ST]
"!!ARBvp1.0
# 26 ALU
PARAM c[14] = { { 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0.xyz, c[10];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
MAD R0.xyz, R2, c[9].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[11];
DP4 R3.z, R1, c[7];
DP4 R3.x, R1, c[5];
DP4 R3.y, R1, c[6];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_World2Object]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Vector 11 [_MainTex_ST]
Vector 12 [_BumpMap_ST]
"vs_2_0
; 29 ALU
def c13, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c6
dp4 r4.z, c10, r0
mov r0, c5
mov r1.w, c13.x
mov r1.xyz, c9
dp4 r4.y, c10, r0
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r2.xyz, r2, c8.w, -v0
mov r1, c4
dp4 r4.x, c10, r1
dp3 oT1.y, r2, r3
dp3 oT2.y, r3, r4
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
dp3 oT2.z, v2, r4
dp3 oT2.x, v1, r4
mad oT0.zw, v3.xyxy, c12.xyxy, c12
mad oT0.xy, v3, c11, c11.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[19];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[17].w, -vertex.position;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].w, R0, c[16];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 38 ALU
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c21.x
dp4 r0.w, v0, c7
dp3 oT2.y, r2, r0
dp3 oT2.z, v2, r0
dp3 oT2.x, v1, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 oT1.y, r1, r2
dp3 oT1.z, v2, r1
dp3 oT1.x, r1, v1
dp4 oT3.w, r0, c15
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 34 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[19];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[17].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 37 ALU
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c21.x
dp3 oT2.y, r2, r0
dp3 oT2.z, v2, r0
dp3 oT2.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 oT1.y, r1, r2
dp3 oT1.z, v2, r1
dp3 oT1.x, r1, v1
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 32 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0.w, c[0].x;
MOV R0.xyz, c[18];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[17].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[19];
DP3 result.texcoord[1].y, R0, R2;
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 32 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 35 ALU
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1.w, c21.x
mov r1.xyz, c17
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c16.w, -v0
mov r1, c8
dp4 r4.x, c18, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT1.y, r2, r3
dp3 oT2.y, r3, r4
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
dp3 oT2.z, v2, r4
dp3 oT2.x, v1, r4
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 46 ALU, 4 TEX
PARAM c[7] = { program.local[0..4],
		{ 0, 0.5, 0.41999999, 2 },
		{ 1, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[1];
ADD R0.y, R1.z, c[5].z;
RCP R0.y, R0.y;
MOV R0.x, c[3];
MUL R0.x, R0, c[5].y;
MAD R0.w, R0, c[3].x, -R0.x;
MUL R1.xy, R1, R0.y;
MAD R0.xy, R0.w, R1, fragment.texcoord[0].zwzw;
MAD R1.xy, R0.w, R1, fragment.texcoord[0];
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
MOV R2.zw, c[6].xyxy;
MOV result.color.w, c[5].x;
TEX R3.yw, R0, texture[2], 2D;
TEX R0.w, R0.w, texture[3], 2D;
TEX R1, R1, texture[1], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R2.x, R0.x;
MAD R0.xy, R3.wyzw, c[5].w, -R2.z;
MUL R2.xyz, R2.x, fragment.texcoord[2];
MAD R3.xyz, R0.z, fragment.texcoord[1], R2;
MUL R3.w, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R3.w;
DP3 R3.w, R3, R3;
ADD R0.z, R0, c[6].x;
RSQ R3.w, R3.w;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
MUL R3.xyz, R3.w, R3;
DP3 R3.x, R0, R3;
DP3 R2.x, R0, R2;
MUL R0.xyz, R1, c[2];
MUL R3.y, R2.w, c[4].x;
MUL R1.xyz, R0, c[0];
MAX R2.w, R3.x, c[5].x;
POW R2.w, R2.w, R3.y;
MAX R2.x, R2, c[5];
MOV R0.xyz, c[1];
MUL R1.w, R2, R1;
MUL R1.xyz, R1, R2.x;
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, c[5];
MAD R0.xyz, R0, R1.w, R1;
MUL result.color.xyz, R0, R0.w;
END
# 46 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_2_0
; 53 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
mov_pp r1.x, c5
mov r2.y, t0.w
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c3, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
mad_pp r1.x, r0.w, c3, -r1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r3.xy, r3, r2.x
mov r2.x, t0.z
mad r4.xy, r1.x, r3, r2
mad r1.xy, r1.x, r3, t0
dp3 r2.x, t3, t3
mov r3.xy, r2.x
mov_pp r0.w, c6.y
texld r2, r1, s1
texld r1, r4, s2
texld r6, r3, s3
mul_pp r2.xyz, r2, c2
mov r3.y, r1
mov r3.x, r1.w
mad_pp r4.xy, r3, c5.z, c5.w
dp3_pp r1.x, t2, t2
rsq_pp r3.x, r1.x
mul_pp r3.xyz, r3.x, t2
mul_pp r1.x, r4.y, r4.y
mad_pp r5.xyz, r0.x, t1, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r5, r5
rsq_pp r0.x, r0.x
rcp_pp r4.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r5
mov_pp r0.x, c4
dp3_pp r1.x, r4, r1
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r5.x, r1.x, r0.x
dp3_pp r1.x, r4, r3
mov r0.x, r5.x
max_pp r1.x, r1, c6.y
mul_pp r2.xyz, r2, c0
mul_pp r3.xyz, r2, r1.x
mov_pp r2.xyz, c0
mul r0.x, r0, r2.w
mul_pp r2.xyz, c1, r2
mul_pp r1.x, r6, c5.z
mad r0.xyz, r2, r0.x, r3
mul r0.xyz, r0, r1.x
mov_pp oC0, r0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 41 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0, 0.5, 0.41999999, 2 },
		{ 1, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R2.z, R0.x;
MUL R0.xyz, R2.z, fragment.texcoord[1];
MOV R1.x, c[3];
ADD R0.z, R0, c[5];
MUL R1.z, R1.x, c[5].y;
RCP R0.z, R0.z;
MUL R1.xy, R0, R0.z;
MAD R0.z, R0.w, c[3].x, -R1;
MAD R0.xy, R0.z, R1, fragment.texcoord[0];
MAD R1.xy, R0.z, R1, fragment.texcoord[0].zwzw;
MOV R2.xy, c[6];
MOV result.color.w, c[5].x;
TEX R1.yw, R1, texture[2], 2D;
TEX R0, R0, texture[1], 2D;
MAD R2.xw, R1.wyzy, c[5].w, -R2.x;
MOV R1.xyz, fragment.texcoord[2];
MAD R1.xyz, R2.z, fragment.texcoord[1], R1;
DP3 R2.z, R1, R1;
RSQ R2.z, R2.z;
MUL R1.w, R2, R2;
MAD R1.w, -R2.x, R2.x, -R1;
ADD R1.w, R1, c[6].x;
MUL R0.xyz, R0, c[2];
MUL R1.xyz, R2.z, R1;
RSQ R1.w, R1.w;
RCP R2.z, R1.w;
DP3 R1.y, R2.xwzw, R1;
MAX R1.y, R1, c[5].x;
MUL R1.x, R2.y, c[4];
POW R1.x, R1.y, R1.x;
MUL R0.w, R1.x, R0;
DP3 R1.x, R2.xwzw, fragment.texcoord[2];
MAX R1.w, R1.x, c[5].x;
MUL R0.xyz, R0, c[0];
MOV R1.xyz, c[1];
MUL R0.xyz, R0, R1.w;
MUL R1.xyz, R1, c[0];
MAD R0.xyz, R1, R0.w, R0;
MUL result.color.xyz, R0, c[5].w;
END
# 41 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"ps_2_0
; 47 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
mov_pp r1.x, c5
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c3, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
mad_pp r1.x, r0.w, c3, -r1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r2.xy, r3, r2.x
mov r3.y, t0.w
mov r3.x, t0.z
mad r3.xy, r1.x, r2, r3
mad r2.xy, r1.x, r2, t0
mov_pp r0.w, c6.y
texld r1, r3, s2
texld r2, r2, s1
mov r1.x, r1.w
mad_pp r4.xy, r1, c5.z, c5.w
mul_pp r1.x, r4.y, r4.y
mov_pp r3.xyz, t2
mad_pp r3.xyz, r0.x, t1, r3
dp3_pp r0.x, r3, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r1.x, r1, c6
rsq_pp r1.x, r1.x
rcp_pp r4.z, r1.x
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r3
dp3_pp r1.x, r4, r1
mov_pp r0.x, c4
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r3.x, r1.x, r0.x
mov r0.x, r3.x
mul_pp r2.xyz, r2, c2
mul_pp r3.xyz, r2, c0
dp3_pp r1.x, r4, t2
max_pp r1.x, r1, c6.y
mov_pp r2.xyz, c0
mul r0.x, r0, r2.w
mul_pp r1.xyz, r3, r1.x
mul_pp r2.xyz, c1, r2
mad r0.xyz, r2, r0.x, r1
mul r0.xyz, r0, c5.z
mov_pp oC0, r0
"
}
SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 52 ALU, 5 TEX
PARAM c[7] = { program.local[0..4],
		{ 0, 0.5, 0.41999999, 2 },
		{ 1, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[1];
ADD R0.y, R1.z, c[5].z;
RCP R0.y, R0.y;
MOV R0.x, c[3];
MUL R0.x, R0, c[5].y;
MUL R1.xy, R1, R0.y;
MAD R0.w, R0, c[3].x, -R0.x;
MAD R0.xy, R0.w, R1, fragment.texcoord[0].zwzw;
MAD R1.zw, R0.w, R1.xyxy, fragment.texcoord[0].xyxy;
RCP R2.x, fragment.texcoord[3].w;
MAD R1.xy, fragment.texcoord[3], R2.x, c[5].y;
MOV R3.zw, c[6].xyxy;
DP3 R3.x, fragment.texcoord[3], fragment.texcoord[3];
MOV result.color.w, c[5].x;
TEX R2, R1.zwzw, texture[1], 2D;
TEX R4.yw, R0, texture[2], 2D;
TEX R0.w, R1, texture[3], 2D;
TEX R1.w, R3.x, texture[4], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R0.x;
MAD R0.xy, R4.wyzw, c[5].w, -R3.z;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MAD R3.xyz, R0.z, fragment.texcoord[1], R1;
MUL R4.x, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R4.x;
DP3 R4.x, R3, R3;
ADD R0.z, R0, c[6].x;
RSQ R4.x, R4.x;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
MUL R3.xyz, R4.x, R3;
DP3 R3.x, R0, R3;
DP3 R1.x, R0, R1;
MUL R0.xyz, R2, c[2];
SLT R2.x, c[5], fragment.texcoord[3].z;
MUL R0.w, R2.x, R0;
MUL R0.w, R0, R1;
MAX R1.x, R1, c[5];
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.x;
MOV R1.xyz, c[1];
MUL R3.y, R3.w, c[4].x;
MAX R3.x, R3, c[5];
POW R3.x, R3.x, R3.y;
MUL R2.w, R3.x, R2;
MUL R1.xyz, R1, c[0];
MUL R0.w, R0, c[5];
MAD R0.xyz, R1, R2.w, R0;
MUL result.color.xyz, R0, R0.w;
END
# 52 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_2_0
; 57 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
mov_pp r1.x, c5
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c3, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
mad_pp r1.x, r0.w, c3, -r1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r2.xy, r3, r2.x
mad r5.xy, r1.x, r2, t0
mov r3.y, t0.w
mov r3.x, t0.z
mad r3.xy, r1.x, r2, r3
dp3 r2.x, t3, t3
mov r4.xy, r2.x
rcp r1.x, t3.w
mad r1.xy, t3, r1.x, c5.x
mov_pp r0.w, c6.y
texld r3, r3, s2
texld r1, r1, s3
texld r2, r5, s1
texld r6, r4, s4
mov r3.x, r3.w
mul_pp r2.xyz, r2, c2
mad_pp r4.xy, r3, c5.z, c5.w
dp3_pp r1.x, t2, t2
rsq_pp r3.x, r1.x
mul_pp r3.xyz, r3.x, t2
mul_pp r1.x, r4.y, r4.y
mad_pp r5.xyz, r0.x, t1, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r5, r5
rsq_pp r0.x, r0.x
rcp_pp r4.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r5
mov_pp r0.x, c4
dp3_pp r1.x, r4, r1
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r5.x, r1.x, r0.x
dp3_pp r1.x, r4, r3
max_pp r1.x, r1, c6.y
mov r0.x, r5.x
mul_pp r2.xyz, r2, c0
mov_pp r3.xyz, c0
mul_pp r2.xyz, r2, r1.x
cmp r1.x, -t3.z, c6.y, c6
mul r0.x, r0, r2.w
mul_pp r3.xyz, c1, r3
mul_pp r1.x, r1, r1.w
mul_pp r1.x, r1, r6
mul_pp r1.x, r1, c5.z
mad r0.xyz, r3, r0.x, r2
mul r0.xyz, r0, r1.x
mov_pp oC0, r0
"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 5 TEX
PARAM c[7] = { program.local[0..4],
		{ 0, 0.5, 0.41999999, 2 },
		{ 1, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R1.w, fragment.texcoord[3], texture[4], CUBE;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[1];
ADD R0.y, R1.z, c[5].z;
RCP R0.y, R0.y;
MOV R0.x, c[3];
MUL R0.x, R0, c[5].y;
MAD R0.w, R0, c[3].x, -R0.x;
MUL R1.xy, R1, R0.y;
MAD R0.xy, R0.w, R1, fragment.texcoord[0].zwzw;
MAD R1.xy, R0.w, R1, fragment.texcoord[0];
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
MOV R3.zw, c[6].xyxy;
MOV result.color.w, c[5].x;
TEX R4.yw, R0, texture[2], 2D;
TEX R0.w, R0.w, texture[3], 2D;
TEX R2, R1, texture[1], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R0.x;
MAD R0.xy, R4.wyzw, c[5].w, -R3.z;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MUL R0.w, R0, R1;
MAD R3.xyz, R0.z, fragment.texcoord[1], R1;
MUL R4.x, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R4.x;
DP3 R4.x, R3, R3;
ADD R0.z, R0, c[6].x;
RSQ R4.x, R4.x;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
MUL R3.xyz, R4.x, R3;
DP3 R3.x, R0, R3;
DP3 R1.x, R0, R1;
MUL R0.xyz, R2, c[2];
MAX R1.x, R1, c[5];
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.x;
MOV R1.xyz, c[1];
MUL R3.y, R3.w, c[4].x;
MAX R3.x, R3, c[5];
POW R3.x, R3.x, R3.y;
MUL R2.w, R3.x, R2;
MUL R1.xyz, R1, c[0];
MUL R0.w, R0, c[5];
MAD R0.xyz, R1, R2.w, R0;
MUL result.color.xyz, R0, R0.w;
END
# 48 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_2_0
; 53 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
mov_pp r1.x, c5
mov r2.y, t0.w
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c3, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
mad_pp r1.x, r0.w, c3, -r1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r4.xy, r3, r2.x
mov r2.x, t0.z
mad r3.xy, r1.x, r4, r2
mad r4.xy, r1.x, r4, t0
dp3 r2.x, t3, t3
mov r1.xy, r2.x
mov_pp r0.w, c6.y
texld r6, r1, s3
texld r3, r3, s2
texld r1, t3, s4
texld r2, r4, s1
mov r3.x, r3.w
mul_pp r2.xyz, r2, c2
mad_pp r4.xy, r3, c5.z, c5.w
dp3_pp r1.x, t2, t2
rsq_pp r3.x, r1.x
mul_pp r3.xyz, r3.x, t2
mul_pp r1.x, r4.y, r4.y
mad_pp r5.xyz, r0.x, t1, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r5, r5
rsq_pp r0.x, r0.x
rcp_pp r4.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r5
mov_pp r0.x, c4
dp3_pp r1.x, r4, r1
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r5.x, r1.x, r0.x
dp3_pp r1.x, r4, r3
max_pp r1.x, r1, c6.y
mov r0.x, r5.x
mul_pp r2.xyz, r2, c0
mov_pp r3.xyz, c0
mul_pp r2.xyz, r2, r1.x
mul r0.x, r0, r2.w
mul_pp r3.xyz, c1, r3
mul r1.x, r6, r1.w
mul_pp r1.x, r1, c5.z
mad r0.xyz, r3, r0.x, r2
mul r0.xyz, r0, r1.x
mov_pp oC0, r0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 43 ALU, 4 TEX
PARAM c[7] = { program.local[0..4],
		{ 0, 0.5, 0.41999999, 2 },
		{ 1, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[1];
ADD R0.y, R1.z, c[5].z;
RCP R0.y, R0.y;
MOV R0.x, c[3];
MUL R0.x, R0, c[5].y;
MAD R0.x, R0.w, c[3], -R0;
MUL R1.xy, R1, R0.y;
MAD R1.zw, R0.x, R1.xyxy, fragment.texcoord[0].xyxy;
MAD R0.xy, R0.x, R1, fragment.texcoord[0].zwzw;
MOV R2.zw, c[6].xyxy;
MOV result.color.w, c[5].x;
TEX R3.yw, R0, texture[2], 2D;
TEX R0.w, fragment.texcoord[3], texture[3], 2D;
TEX R1, R1.zwzw, texture[1], 2D;
MAD R0.xy, R3.wyzw, c[5].w, -R2.z;
MOV R2.xyz, fragment.texcoord[2];
MUL R3.x, R0.y, R0.y;
MAD R2.xyz, R0.z, fragment.texcoord[1], R2;
MAD R0.z, -R0.x, R0.x, -R3.x;
DP3 R3.x, R2, R2;
ADD R0.z, R0, c[6].x;
RSQ R3.x, R3.x;
RSQ R0.z, R0.z;
MUL R2.xyz, R3.x, R2;
RCP R0.z, R0.z;
DP3 R2.x, R0, R2;
MUL R2.y, R2.w, c[4].x;
MAX R2.x, R2, c[5];
POW R2.x, R2.x, R2.y;
MUL R1.w, R2.x, R1;
DP3 R2.x, R0, fragment.texcoord[2];
MUL R0.xyz, R1, c[2];
MUL R1.xyz, R0, c[0];
MAX R2.x, R2, c[5];
MOV R0.xyz, c[1];
MUL R1.xyz, R1, R2.x;
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, c[5];
MAD R0.xyz, R0, R1.w, R1;
MUL result.color.xyz, R0, R0.w;
END
# 43 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Parallax]
Float 4 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_2_0
; 49 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
mov r4.y, t0.w
mov r4.x, t0.z
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
add r1.x, r3.z, c5.y
rcp r2.x, r1.x
mov_pp r1.x, c5
mul r2.xy, r3, r2.x
mul_pp r1.x, c3, r1
mad_pp r1.x, r0.w, c3, -r1
mad r3.xy, r1.x, r2, t0
mad r1.xy, r1.x, r2, r4
mov_pp r4.xyz, t2
mad_pp r4.xyz, r0.x, t1, r4
mov_pp r0.w, c6.y
texld r2, r3, s1
texld r3, r1, s2
texld r1, t3, s3
mul_pp r2.xyz, r2, c2
mov r1.y, r3
mov r1.x, r3.w
mad_pp r3.xy, r1, c5.z, c5.w
mul_pp r1.x, r3.y, r3.y
mad_pp r1.x, -r3, r3, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r4, r4
rsq_pp r0.x, r0.x
rcp_pp r3.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r4
dp3_pp r1.x, r3, r1
mov_pp r0.x, c4
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r4.x, r1.x, r0.x
dp3_pp r1.x, r3, t2
max_pp r1.x, r1, c6.y
mul_pp r2.xyz, r2, c0
mul_pp r3.xyz, r2, r1.x
mov r0.x, r4.x
mov_pp r2.xyz, c0
mul r0.x, r0, r2.w
mul_pp r2.xyz, c1, r2
mul_pp r1.x, r1.w, c5.z
mad r0.xyz, r2, r0.x, r3
mul r0.xyz, r0, r1.x
mov_pp oC0, r0
"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassBase" "RenderType"="Opaque" }
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_BumpMap_ST]
"!!ARBvp1.0
# 30 ALU
PARAM c[16] = { { 1 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP3 R0.y, R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2].xyz, R0, c[13].w;
DP3 R0.y, R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3].xyz, R0, c[13].w;
DP3 R0.y, R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[4].xyz, R0, c[13].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 30 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_BumpMap_ST]
"vs_2_0
; 31 ALU
def c15, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
mov r0.xyz, c13
mov r0.w, c15.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c12.w, -v0
dp3 oT1.y, r0, r1
dp3 oT1.z, v2, r0
dp3 oT1.x, r0, v1
dp3 r0.y, r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul oT2.xyz, r0, c12.w
dp3 r0.y, r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul oT3.xyz, r0, c12.w
dp3 r0.y, r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul oT4.xyz, r0, c12.w
mad oT0.xy, v3, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Float 0 [_Parallax]
Float 1 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 2 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 0.5, 0.41999999, 2, 1 } };
TEMP R0;
TEMP R1;
TEX R0.w, fragment.texcoord[0], texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
ADD R1.x, R0.z, c[2].y;
MOV R0.z, c[0].x;
RCP R1.x, R1.x;
MUL R1.xy, R0, R1.x;
MUL R0.z, R0, c[2].x;
MAD R0.x, R0.w, c[0], -R0.z;
MAD R0.xy, R0.x, R1, fragment.texcoord[0];
MOV result.color.w, c[1].x;
TEX R0.yw, R0, texture[2], 2D;
MAD R0.xy, R0.wyzw, c[2].z, -c[2].w;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[2].w;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.z, fragment.texcoord[4], R0;
DP3 R1.x, R0, fragment.texcoord[2];
DP3 R1.y, R0, fragment.texcoord[3];
MAD result.color.xyz, R1, c[2].x, c[2].x;
END
# 23 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Float 0 [_Parallax]
Float 1 [_Shininess]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 2 [_BumpMap] 2D
"ps_2_0
; 23 ALU, 2 TEX
dcl_2d s0
dcl_2d s2
def c2, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c3, 1.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r0, t0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, t1
add r0.x, r2.z, c2.y
rcp r1.x, r0.x
mov_pp r0.x, c2
mul_pp r0.x, c0, r0
mul r1.xy, r2, r1.x
mad_pp r0.x, r0.w, c0, -r0
mad r0.xy, r0.x, r1, t0
texld r0, r0, s2
mov r0.x, r0.w
mad_pp r1.xy, r0, c2.z, c2.w
mul_pp r0.x, r1.y, r1.y
mad_pp r0.x, -r1, r1, -r0
add_pp r0.x, r0, c3
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3 r0.z, t4, r1
dp3 r0.x, r1, t2
dp3 r0.y, r1, t3
mad_pp r0.xyz, r0, c2.x, c2.x
mov_pp r0.w, c1.x
mov_pp oC0, r0
"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassFinal" "RenderType"="Opaque" }
  ZWrite Off
Program "vp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 5 [_World2Object]
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Vector 12 [_MainTex_ST]
Vector 13 [_BumpMap_ST]
Vector 14 [_Illum_ST]
"!!ARBvp1.0
# 25 ALU
PARAM c[15] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[11];
MOV R1.w, c[0].x;
DP4 R0.w, vertex.position, c[4];
DP4 R2.z, R1, c[7];
DP4 R2.x, R1, c[5];
DP4 R2.y, R1, c[6];
MAD R2.xyz, R2, c[10].w, -vertex.position;
DP3 result.texcoord[2].y, R2, R0;
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[9].x;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[14], c[14].zwzw;
END
# 25 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_World2Object]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Vector 12 [_MainTex_ST]
Vector 13 [_BumpMap_ST]
Vector 14 [_Illum_ST]
"vs_2_0
; 26 ALU
def c15, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
mov r1.xyz, c11
mov r1.w, c15.x
dp4 r0.w, v0, c3
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r2.xyz, r2, c10.w, -v0
dp3 oT2.y, r2, r0
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c15.y
mul r1.y, r1, c8.x
dp3 oT2.z, v2, r2
dp3 oT2.x, r2, v1
mad oT3.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.zw, v3.xyxy, c13.xyxy, c13
mad oT0.xy, v3, c12, c12.zwzw
mad oT1.xy, v3, c14, c14.zwzw
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Vector 17 [_ProjectionParams]
Vector 18 [unity_Scale]
Vector 19 [_WorldSpaceCameraPos]
Vector 20 [unity_LightmapST]
Vector 21 [unity_ShadowFadeCenterAndType]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
Vector 24 [_Illum_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[25] = { { 1, 0.5 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..24] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[19];
MOV R1.w, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R2.z, R1, c[15];
DP4 R2.x, R1, c[13];
DP4 R2.y, R1, c[14];
MAD R2.xyz, R2, c[18].w, -vertex.position;
DP3 result.texcoord[2].y, R2, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[17].x;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0];
ADD R0.y, R0.x, -c[21].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[21];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
MOV result.texcoord[3].zw, R0;
MUL result.texcoord[5].xyz, R1, c[21].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[23].xyxy, c[23];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[22], c[22].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[24], c[24].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[20], c[20].zwzw;
MUL result.texcoord[5].w, -R0.x, R0.y;
END
# 35 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Vector 16 [_ProjectionParams]
Vector 17 [_ScreenParams]
Vector 18 [unity_Scale]
Vector 19 [_WorldSpaceCameraPos]
Vector 20 [unity_LightmapST]
Vector 21 [unity_ShadowFadeCenterAndType]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
Vector 24 [_Illum_ST]
"vs_2_0
; 36 ALU
def c25, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
mov r1.xyz, c19
mov r1.w, c25.x
dp4 r0.w, v0, c7
dp4 r2.z, r1, c14
dp4 r2.x, r1, c12
dp4 r2.y, r1, c13
mad r2.xyz, r2, c18.w, -v0
dp3 oT2.y, r2, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c16.x
mad oT3.xy, r1.z, c17.zwzw, r1
mov oPos, r0
mov r0.x, c21.w
add r0.y, c25.x, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c21
dp3 oT2.z, v2, r2
dp3 oT2.x, r2, v1
mov oT3.zw, r0
mul oT5.xyz, r1, c21.w
mad oT0.zw, v3.xyxy, c23.xyxy, c23
mad oT0.xy, v3, c22, c22.zwzw
mad oT1.xy, v3, c24, c24.zwzw
mad oT4.xy, v4, c20, c20.zwzw
mul oT5.w, -r0.x, r0.y
"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Parallax]
Vector 3 [unity_Ambient]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 4 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 28 ALU, 4 TEX
PARAM c[5] = { program.local[0..3],
		{ 0.5, 0.41999999 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TXP R2, fragment.texcoord[3], texture[4], 2D;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[2];
ADD R0.y, R1.z, c[4];
RCP R0.y, R0.y;
MOV R0.x, c[2];
MUL R0.x, R0, c[4];
MUL R1.xy, R1, R0.y;
MAD R0.x, R0.w, c[2], -R0;
MAD R0.zw, R0.x, R1.xyxy, fragment.texcoord[1].xyxy;
MAD R0.xy, R0.x, R1, fragment.texcoord[0];
LG2 R2.w, R2.w;
TEX R1, R0, texture[1], 2D;
TEX R0.w, R0.zwzw, texture[2], 2D;
MUL R2.w, R1, -R2;
MUL R1, R1, c[1];
LG2 R0.x, R2.x;
LG2 R0.z, R2.z;
LG2 R0.y, R2.y;
ADD R0.xyz, -R0, c[3];
MUL R2.xyz, R0, c[0];
MUL R2.xyz, R2, R2.w;
MUL R3.xyz, R1, R0.w;
MAD R0.xyz, R1, R0, R2;
ADD result.color.xyz, R0, R3;
MAD result.color.w, R2, c[0], R1;
END
# 28 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Parallax]
Vector 3 [unity_Ambient]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 4 [_LightBuffer] 2D
"ps_2_0
; 27 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s4
def c4, 0.50000000, 0.41999999, 0, 0
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, t2
add r0.x, r2.z, c4.y
rcp r1.x, r0.x
mov_pp r0.x, c4
mul_pp r0.x, c2, r0
mul r1.xy, r2, r1.x
mad_pp r0.x, r0.w, c2, -r0
mad r2.xy, r0.x, r1, t1
mad r1.xy, r0.x, r1, t0
texld r0, r2, s2
texldp r2, t3, s4
texld r1, r1, s1
log_pp r0.z, r2.z
log_pp r0.y, r2.y
log_pp r0.x, r2.x
add_pp r2.xyz, -r0, c3
log_pp r0.x, r2.w
mul_pp r0.x, r1.w, -r0
mul_pp r3.xyz, r2, c0
mul_pp r1, r1, c1
mul_pp r3.xyz, r3, r0.x
mad_pp r2.xyz, r1, r2, r3
mul r1.xyz, r1, r0.w
mad_pp r0.w, r0.x, c0, r1
add_pp r0.xyz, r2, r1
mov_pp oC0, r0
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Parallax]
Vector 3 [unity_LightmapFade]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
SetTexture 6 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 39 ALU, 6 TEX
PARAM c[5] = { program.local[0..3],
		{ 0.5, 0.41999999, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TXP R2, fragment.texcoord[3], texture[4], 2D;
TEX R3, fragment.texcoord[4], texture[5], 2D;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R4, fragment.texcoord[4], texture[6], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[2];
ADD R0.y, R1.z, c[4];
RCP R0.y, R0.y;
MOV R0.x, c[2];
MUL R0.x, R0, c[4];
MUL R1.xy, R1, R0.y;
MAD R0.x, R0.w, c[2], -R0;
MAD R0.zw, R0.x, R1.xyxy, fragment.texcoord[1].xyxy;
MAD R0.xy, R0.x, R1, fragment.texcoord[0];
LG2 R2.x, R2.x;
LG2 R2.y, R2.y;
LG2 R2.z, R2.z;
LG2 R2.w, R2.w;
TEX R1, R0, texture[1], 2D;
TEX R0.w, R0.zwzw, texture[2], 2D;
MUL R0.xyz, R3.w, R3;
MUL R2.w, R1, -R2;
MUL R1, R1, c[1];
DP4 R3.w, fragment.texcoord[5], fragment.texcoord[5];
MUL R3.xyz, R4.w, R4;
MUL R3.xyz, R3, c[4].z;
RSQ R3.w, R3.w;
RCP R3.w, R3.w;
MAD R0.xyz, R0, c[4].z, -R3;
MAD_SAT R3.w, R3, c[3].z, c[3];
MAD R0.xyz, R3.w, R0, R3;
ADD R0.xyz, -R2, R0;
MUL R2.xyz, R0, c[0];
MUL R2.xyz, R2, R2.w;
MUL R3.xyz, R1, R0.w;
MAD R0.xyz, R1, R0, R2;
ADD result.color.xyz, R0, R3;
MAD result.color.w, R2, c[0], R1;
END
# 39 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Parallax]
Vector 3 [unity_LightmapFade]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Illum] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
SetTexture 6 [unity_LightmapInd] 2D
"ps_2_0
; 36 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s4
dcl_2d s5
dcl_2d s6
def c4, 0.50000000, 0.41999999, 8.00000000, 0
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3
dcl t4.xy
dcl t5
texld r3, t4, s5
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r3.xyz, r3.w, r3
texld r0, r0, s0
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, t2
add r0.x, r2.z, c4.y
rcp r1.x, r0.x
mov_pp r0.x, c4
mul_pp r0.x, c2, r0
mul r1.xy, r2, r1.x
mad_pp r0.x, r0.w, c2, -r0
mad r2.xy, r0.x, r1, t1
mad r0.xy, r0.x, r1, t0
texld r1, r0, s1
texld r4, r2, s2
texldp r2, t3, s4
texld r0, t4, s6
mul_pp r4.xyz, r0.w, r0
mul_pp r4.xyz, r4, c4.z
dp4 r0.x, t5, t5
rsq r0.x, r0.x
rcp r0.x, r0.x
mad_pp r3.xyz, r3, c4.z, -r4
mad_sat r0.x, r0, c3.z, c3.w
mad_pp r0.xyz, r0.x, r3, r4
log_pp r2.x, r2.x
log_pp r2.y, r2.y
log_pp r2.z, r2.z
add_pp r2.xyz, -r2, r0
log_pp r0.x, r2.w
mul_pp r0.x, r1.w, -r0
mul_pp r1, r1, c1
mul_pp r3.xyz, r2, c0
mul_pp r3.xyz, r3, r0.x
mad_pp r2.xyz, r1, r2, r3
mad_pp r0.w, r0.x, c0, r1
mul r1.xyz, r1, r4.w
add_pp r0.xyz, r2, r1
mov_pp oC0, r0
"
}
}
 }
}
Fallback "Self-Illumin/Bumped Specular"
}