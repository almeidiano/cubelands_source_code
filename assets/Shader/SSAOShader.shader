//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/SSAO" {
Properties {
 _MainTex ("", 2D) = "" {}
 _RandomTexture ("", 2D) = "" {}
 _SSAO ("", 2D) = "" {}
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 5 [_NoiseScale]
Vector 6 [_CameraDepthNormalsTexture_ST]
"3.0-!!ARBvp1.0
# 6 ALU
PARAM c[7] = { program.local[0],
		state.matrix.mvp,
		program.local[5..6] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[6], c[6].zwzw;
MUL result.texcoord[1].xy, vertex.texcoord[0], c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_NoiseScale]
Vector 5 [_CameraDepthNormalsTexture_ST]
"vs_3_0
; 6 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v1
mad o1.xy, v1, c5, c5.zwzw
mul o2.xy, v1, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ProjectionParams]
Vector 1 [_Params]
SetTexture 0 [_RandomTexture] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 162 ALU, 10 TEX
PARAM c[12] = { program.local[0..1],
		{ 2, 1, 3.5553999, 0 },
		{ 0.88491488, 0.28420761, 0.36852399, -1 },
		{ -1.7776999, 1, 0.30000001, 0.0039215689 },
		{ 0.1871898, -0.70276397, -0.2317479, 0.125 },
		{ -0.2484578, 0.25553221, 0.34894389 },
		{ 0.1399992, -0.33577019, 0.55967891 },
		{ -0.4796457, 0.093987659, -0.58026528 },
		{ -0.310725, -0.191367, 0.056136861 },
		{ 0.32307819, 0.022072719, -0.41887251 },
		{ 0.01305719, 0.58723211, -0.119337 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R5, fragment.texcoord[0], texture[1], 2D;
MUL R0.xyz, R5, c[2].zzww;
ADD R2.xyz, R0, c[4].xxyw;
TEX R0.xyz, fragment.texcoord[1], texture[0], 2D;
MAD R1.xyz, R0, c[2].x, -c[2].y;
DP3 R0.w, R2, R2;
RCP R0.x, R0.w;
MUL R0.w, R0.x, c[2].x;
DP3 R1.w, R1, c[10];
MUL R3.xyz, R1, R1.w;
MUL R5.xy, R5.zwzw, c[4].ywzw;
DP3 R0.y, R1, c[11];
MUL R0.xyz, R1, R0.y;
MUL R0.xyz, -R0, c[2].x;
ADD R1.w, R5.x, R5.y;
MUL R3.xyz, -R3, c[2].x;
MUL R2.xy, R0.w, R2;
ADD R2.z, R0.w, -c[2].y;
ADD R4.xyz, R0, c[11];
MUL R1.w, R1, c[0].z;
MOV R0.w, c[3];
DP3 R0.x, R2, R4;
CMP R2.w, R0.x, c[2].y, R0;
MUL R0.xyz, R2, c[4].z;
MAD R4.xyz, R4, -R2.w, R0;
ADD R3.xyz, R3, c[10];
DP3 R2.w, R2, R3;
CMP R3.w, R2, c[2].y, R0;
MAD R3.xyz, R3, -R3.w, R0;
RCP R2.w, R1.w;
MUL R2.w, R2, c[1].x;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
TEX R5.zw, R3, texture[1], 2D;
MUL R3.xy, R5.zwzw, c[4].ywzw;
TEX R6.zw, R4, texture[1], 2D;
MAD R3.w, -R4.z, c[1].x, R1;
DP3 R4.w, R1, c[8];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.z, -R3.x, c[0], R3;
MUL R3.xy, R6.zwzw, c[4].ywzw;
ADD R3.x, R3, R3.y;
MAD_SAT R3.x, -R3, c[0].z, R3.w;
ADD R3.y, -R3.x, c[2];
ADD R3.w, -R3.z, c[2].y;
POW R4.x, R3.w, c[1].z;
POW R3.y, R3.y, c[1].z;
ADD R3.x, R3, -c[1].y;
CMP R3.w, -R3.x, R3.y, c[2];
ADD R4.x, R3.w, R4;
ADD R3.y, R3.z, -c[1];
CMP R3.w, -R3.y, R4.x, R3;
DP3 R3.x, R1, c[9];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[9];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[8];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[7];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[6];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[7];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[6];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[5];
MUL R3.xyz, R1, R3.x;
DP3 R4.x, R1, c[3];
MUL R1.xyz, R1, R4.x;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[5];
DP3 R4.x, R2, R3;
MUL R1.xyz, -R1, c[2].x;
ADD R1.xyz, R1, c[3];
CMP R4.y, R4.x, c[2], R0.w;
DP3 R4.x, R1, R2;
MAD R2.xyz, R3, -R4.y, R0;
CMP R0.w, R4.x, c[2].y, R0;
MAD R0.xyz, R1, -R0.w, R0;
MAD R2.xy, R2.w, R2, fragment.texcoord[0];
TEX R4.zw, R2, texture[1], 2D;
MUL R1.xy, R4.zwzw, c[4].ywzw;
MAD R0.xy, R0, R2.w, fragment.texcoord[0];
MAD R1.z, -R2, c[1].x, R1.w;
ADD R0.w, R1.x, R1.y;
MAD_SAT R0.w, -R0, c[0].z, R1.z;
TEX R2.zw, R0, texture[1], 2D;
MUL R0.xy, R2.zwzw, c[4].ywzw;
ADD R0.x, R0, R0.y;
ADD R1.x, -R0.w, c[2].y;
MAD R0.z, -R0, c[1].x, R1.w;
MAD_SAT R0.x, -R0, c[0].z, R0.z;
POW R0.y, R1.x, c[1].z;
ADD R1.x, -R0, c[2].y;
ADD R0.z, R3.w, R0.y;
ADD R0.y, R0.w, -c[1];
CMP R0.y, -R0, R0.z, R3.w;
POW R1.x, R1.x, c[1].z;
ADD R0.z, R0.y, R1.x;
ADD R0.x, R0, -c[1].y;
CMP R0.x, -R0, R0.z, R0.y;
MUL R0.x, -R0, c[5].w;
ADD result.color, R0.x, c[2].y;
END
# 162 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ProjectionParams]
Vector 1 [_Params]
SetTexture 0 [_RandomTexture] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"ps_3_0
; 164 ALU, 10 TEX
dcl_2d s0
dcl_2d s1
def c2, 2.00000000, -1.00000000, 0.30000001, 1.00000000
def c3, 0.88491488, 0.28420761, 0.36852399, 2.00000000
def c4, 3.55539989, 0.00000000, -1.77769995, 1.00000000
def c5, 1.00000000, 0.00392157, 0.12500000, 0
def c6, 0.18718980, -0.70276397, -0.23174790, 2.00000000
def c7, -0.24845780, 0.25553221, 0.34894389, 2.00000000
def c8, 0.13999920, -0.33577019, 0.55967891, 2.00000000
def c9, -0.47964570, 0.09398766, -0.58026528, 2.00000000
def c10, -0.31072500, -0.19136700, 0.05613686, 2.00000000
def c11, 0.32307819, 0.02207272, -0.41887251, 2.00000000
def c12, 0.01305719, 0.58723211, -0.11933700, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
texld r0.xyz, v1, s0
mad r2.xyz, r0, c2.x, c2.y
texld r5, v0, s1
mad r1.xyz, r5, c4.xxyw, c4.zzww
dp3 r0.w, r1, r1
rcp r0.x, r0.w
mul r0.w, r0.x, c2.x
dp3 r0.y, r2, c12
mul r0.xyz, r2, r0.y
mul r1.xy, r0.w, r1
add r1.z, r0.w, c2.y
mad r0.xyz, -r0, c12.w, c12
dp3 r0.w, r1, r0
cmp r1.w, r0, c2.y, -c2.y
mul r4.xyz, r1, c2.z
mad_pp r3.xyz, r0, -r1.w, r4
dp3 r0.w, r2, c11
mul r0.xyz, r2, r0.w
mul r5.xy, r5.zwzw, c5
add r0.w, r5.x, r5.y
mul r1.w, r0, c0.z
mad r0.xyz, -r0, c11.w, c11
dp3 r2.w, r1, r0
cmp r2.w, r2, c2.y, -c2.y
mad_pp r0.xyz, r0, -r2.w, r4
rcp r0.w, r1.w
mul r2.w, r0, c1.x
mad r3.xy, r2.w, r3, v0
mad r0.xy, r2.w, r0, v0
texld r5.zw, r0, s1
mul r0.xy, r5.zwzw, c5
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r4.w, -r0.x, c0.z, r0.z
texld r6.zw, r3, s1
mul r0.xy, r6.zwzw, c5
mad r0.z, -r3, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.x, -r0, c0.z, r0.z
add r3.x, -r4.w, c2.w
pow r0, r3.x, c1.z
add r5.y, -r5.x, c2.w
pow r3, r5.y, c1.z
mov r0.w, r0.x
mov r0.y, r3.x
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, c4.y, r0.y
add r0.w, r0.z, r0
add r0.y, r4.w, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c10
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c9
mad r3.xyz, -r0, c10.w, c10
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c9.w, c9
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c8
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c7
mad r3.xyz, -r0, c8.w, c8
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
mad r0.xyz, -r0, c7.w, c7
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
texld r5.zw, r3, s1
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
pow r3, r0.w, c1.z
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
dp3 r3.x, r2, c3
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r0.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c6
mul r0.xyz, r2, r0.x
mul r2.xyz, r2, r3.x
mad r0.xyz, -r0, c6.w, c6
dp3 r3.x, r1, r0
mad r2.xyz, -r2, c3.w, c3
dp3 r1.x, r2, r1
cmp r3.x, r3, c2.y, -c2.y
mad_pp r0.xyz, r0, -r3.x, r4
mad r0.xy, r2.w, r0, v0
cmp r1.x, r1, c2.y, -c2.y
mad_pp r1.xyz, r2, -r1.x, r4
texld r3.zw, r0, s1
mad r0.xy, r1, r2.w, v0
texld r2.zw, r0, s1
mul r0.xy, r2.zwzw, c5
mad r2.x, -r0.z, c1, r1.w
mul r1.xy, r3.zwzw, c5
add r0.z, r1.x, r1.y
mad_sat r0.z, -r0, c0, r2.x
add r1.y, -r0.z, c2.w
pow r2, r1.y, c1.z
add r0.x, r0, r0.y
mad r1.x, -r1.z, c1, r1.w
mad_sat r0.x, -r0, c0.z, r1
add r0.y, -r0.x, c2.w
pow r1, r0.y, c1.z
mov r0.y, r2.x
add r1.y, r0.w, r0
add r0.y, r0.z, -c1
cmp r0.y, -r0, r0.w, r1
add r0.z, r0.y, r1.x
add r0.x, r0, -c1.y
cmp r0.x, -r0, r0.y, r0.z
mad oC0, -r0.x, c5.z, c5.x
"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 5 [_NoiseScale]
Vector 6 [_CameraDepthNormalsTexture_ST]
"3.0-!!ARBvp1.0
# 6 ALU
PARAM c[7] = { program.local[0],
		state.matrix.mvp,
		program.local[5..6] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[6], c[6].zwzw;
MUL result.texcoord[1].xy, vertex.texcoord[0], c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_NoiseScale]
Vector 5 [_CameraDepthNormalsTexture_ST]
"vs_3_0
; 6 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v1
mad o1.xy, v1, c5, c5.zwzw
mul o2.xy, v1, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ProjectionParams]
Vector 1 [_Params]
SetTexture 0 [_RandomTexture] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 270 ALU, 16 TEX
PARAM c[18] = { program.local[0..1],
		{ 2, 1, 3.5553999, 0 },
		{ -0.6984446, -0.60034221, -0.040169429, -1 },
		{ -1.7776999, 1, 0.30000001, 0.0039215689 },
		{ 0.037044641, -0.93913102, 0.13587651, 0.071428575 },
		{ 0.70261252, 0.1648249, 0.02250625 },
		{ -0.32154989, 0.68320483, -0.3433446 },
		{ -0.019565029, -0.31080621, -0.41066301 },
		{ -0.32949659, 0.02684341, -0.40218359 },
		{ 0.19861419, 0.1767239, 0.43804911 },
		{ 0.18916769, -0.1283755, -0.098735571 },
		{ -0.088296533, 0.1649759, 0.13958789 },
		{ 0.38207859, -0.3241398, 0.41128251 },
		{ -0.62566841, 0.1241661, 0.1163932 },
		{ -0.23052961, -0.19000851, 0.50253958 },
		{ 0.1617837, 0.13385519, -0.35304859 },
		{ 0.4010039, 0.88993812, -0.017517719 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R5, fragment.texcoord[0], texture[1], 2D;
MUL R0.xyz, R5, c[2].zzww;
ADD R2.xyz, R0, c[4].xxyw;
TEX R0.xyz, fragment.texcoord[1], texture[0], 2D;
MAD R1.xyz, R0, c[2].x, -c[2].y;
DP3 R0.w, R2, R2;
RCP R0.x, R0.w;
MUL R0.w, R0.x, c[2].x;
DP3 R1.w, R1, c[16];
MUL R3.xyz, R1, R1.w;
MUL R5.xy, R5.zwzw, c[4].ywzw;
DP3 R0.y, R1, c[17];
MUL R0.xyz, R1, R0.y;
MUL R0.xyz, -R0, c[2].x;
ADD R1.w, R5.x, R5.y;
MUL R3.xyz, -R3, c[2].x;
MUL R2.xy, R0.w, R2;
ADD R2.z, R0.w, -c[2].y;
ADD R4.xyz, R0, c[17];
MUL R1.w, R1, c[0].z;
MOV R0.w, c[3];
DP3 R0.x, R2, R4;
CMP R2.w, R0.x, c[2].y, R0;
MUL R0.xyz, R2, c[4].z;
MAD R4.xyz, R4, -R2.w, R0;
ADD R3.xyz, R3, c[16];
DP3 R2.w, R2, R3;
CMP R3.w, R2, c[2].y, R0;
MAD R3.xyz, R3, -R3.w, R0;
RCP R2.w, R1.w;
MUL R2.w, R2, c[1].x;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
TEX R5.zw, R3, texture[1], 2D;
MUL R3.xy, R5.zwzw, c[4].ywzw;
TEX R6.zw, R4, texture[1], 2D;
MAD R3.w, -R4.z, c[1].x, R1;
DP3 R4.w, R1, c[14];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.z, -R3.x, c[0], R3;
MUL R3.xy, R6.zwzw, c[4].ywzw;
ADD R3.x, R3, R3.y;
MAD_SAT R3.x, -R3, c[0].z, R3.w;
ADD R3.y, -R3.x, c[2];
ADD R3.w, -R3.z, c[2].y;
POW R4.x, R3.w, c[1].z;
POW R3.y, R3.y, c[1].z;
ADD R3.x, R3, -c[1].y;
CMP R3.w, -R3.x, R3.y, c[2];
ADD R4.x, R3.w, R4;
ADD R3.y, R3.z, -c[1];
CMP R3.w, -R3.y, R4.x, R3;
DP3 R3.x, R1, c[15];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[15];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[14];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[13];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[12];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[13];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[12];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[11];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[10];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[11];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[10];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[9];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[8];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[9];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[8];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[7];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[6];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[7];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[6];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[5];
MUL R3.xyz, R1, R3.x;
DP3 R4.x, R1, c[3];
MUL R1.xyz, R1, R4.x;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[5];
DP3 R4.x, R2, R3;
MUL R1.xyz, -R1, c[2].x;
ADD R1.xyz, R1, c[3];
CMP R4.y, R4.x, c[2], R0.w;
DP3 R4.x, R1, R2;
MAD R2.xyz, R3, -R4.y, R0;
CMP R0.w, R4.x, c[2].y, R0;
MAD R0.xyz, R1, -R0.w, R0;
MAD R2.xy, R2.w, R2, fragment.texcoord[0];
TEX R4.zw, R2, texture[1], 2D;
MUL R1.xy, R4.zwzw, c[4].ywzw;
MAD R0.xy, R0, R2.w, fragment.texcoord[0];
MAD R1.z, -R2, c[1].x, R1.w;
ADD R0.w, R1.x, R1.y;
MAD_SAT R0.w, -R0, c[0].z, R1.z;
TEX R2.zw, R0, texture[1], 2D;
MUL R0.xy, R2.zwzw, c[4].ywzw;
ADD R0.x, R0, R0.y;
ADD R1.x, -R0.w, c[2].y;
MAD R0.z, -R0, c[1].x, R1.w;
MAD_SAT R0.x, -R0, c[0].z, R0.z;
POW R0.y, R1.x, c[1].z;
ADD R1.x, -R0, c[2].y;
ADD R0.z, R3.w, R0.y;
ADD R0.y, R0.w, -c[1];
CMP R0.y, -R0, R0.z, R3.w;
POW R1.x, R1.x, c[1].z;
ADD R0.z, R0.y, R1.x;
ADD R0.x, R0, -c[1].y;
CMP R0.x, -R0, R0.z, R0.y;
MUL R0.x, -R0, c[5].w;
ADD result.color, R0.x, c[2].y;
END
# 270 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ProjectionParams]
Vector 1 [_Params]
SetTexture 0 [_RandomTexture] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"ps_3_0
; 278 ALU, 16 TEX
dcl_2d s0
dcl_2d s1
def c2, 2.00000000, -1.00000000, 0.30000001, 1.00000000
def c3, -0.69844460, -0.60034221, -0.04016943, 2.00000000
def c4, 3.55539989, 0.00000000, -1.77769995, 1.00000000
def c5, 1.00000000, 0.00392157, 0.07142857, 0
def c6, 0.03704464, -0.93913102, 0.13587651, 2.00000000
def c7, 0.70261252, 0.16482490, 0.02250625, 2.00000000
def c8, -0.32154989, 0.68320483, -0.34334460, 2.00000000
def c9, -0.01956503, -0.31080621, -0.41066301, 2.00000000
def c10, -0.32949659, 0.02684341, -0.40218359, 2.00000000
def c11, 0.19861419, 0.17672390, 0.43804911, 2.00000000
def c12, 0.18916769, -0.12837550, -0.09873557, 2.00000000
def c13, -0.08829653, 0.16497590, 0.13958789, 2.00000000
def c14, 0.38207859, -0.32413980, 0.41128251, 2.00000000
def c15, -0.62566841, 0.12416610, 0.11639320, 2.00000000
def c16, -0.23052961, -0.19000851, 0.50253958, 2.00000000
def c17, 0.16178370, 0.13385519, -0.35304859, 2.00000000
def c18, 0.40100390, 0.88993812, -0.01751772, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
texld r0.xyz, v1, s0
mad r2.xyz, r0, c2.x, c2.y
texld r5, v0, s1
mad r1.xyz, r5, c4.xxyw, c4.zzww
dp3 r0.w, r1, r1
rcp r0.x, r0.w
mul r0.w, r0.x, c2.x
dp3 r0.y, r2, c18
mul r0.xyz, r2, r0.y
mul r1.xy, r0.w, r1
add r1.z, r0.w, c2.y
mad r0.xyz, -r0, c18.w, c18
dp3 r0.w, r1, r0
cmp r1.w, r0, c2.y, -c2.y
mul r4.xyz, r1, c2.z
mad_pp r3.xyz, r0, -r1.w, r4
dp3 r0.w, r2, c17
mul r0.xyz, r2, r0.w
mul r5.xy, r5.zwzw, c5
add r0.w, r5.x, r5.y
mul r1.w, r0, c0.z
mad r0.xyz, -r0, c17.w, c17
dp3 r2.w, r1, r0
cmp r2.w, r2, c2.y, -c2.y
mad_pp r0.xyz, r0, -r2.w, r4
rcp r0.w, r1.w
mul r2.w, r0, c1.x
mad r3.xy, r2.w, r3, v0
mad r0.xy, r2.w, r0, v0
texld r5.zw, r0, s1
mul r0.xy, r5.zwzw, c5
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r4.w, -r0.x, c0.z, r0.z
texld r6.zw, r3, s1
mul r0.xy, r6.zwzw, c5
mad r0.z, -r3, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.x, -r0, c0.z, r0.z
add r3.x, -r4.w, c2.w
pow r0, r3.x, c1.z
add r5.y, -r5.x, c2.w
pow r3, r5.y, c1.z
mov r0.w, r0.x
mov r0.y, r3.x
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, c4.y, r0.y
add r0.w, r0.z, r0
add r0.y, r4.w, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c16
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c15
mad r3.xyz, -r0, c16.w, c16
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c15.w, c15
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c14
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c13
mad r3.xyz, -r0, c14.w, c14
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c13.w, c13
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c12
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c11
mad r3.xyz, -r0, c12.w, c12
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c11.w, c11
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c10
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c9
mad r3.xyz, -r0, c10.w, c10
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c9.w, c9
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c8
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c7
mad r3.xyz, -r0, c8.w, c8
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
mad r0.xyz, -r0, c7.w, c7
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
texld r5.zw, r3, s1
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
pow r3, r0.w, c1.z
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
dp3 r3.x, r2, c3
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r0.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c6
mul r0.xyz, r2, r0.x
mul r2.xyz, r2, r3.x
mad r0.xyz, -r0, c6.w, c6
dp3 r3.x, r1, r0
mad r2.xyz, -r2, c3.w, c3
dp3 r1.x, r2, r1
cmp r3.x, r3, c2.y, -c2.y
mad_pp r0.xyz, r0, -r3.x, r4
mad r0.xy, r2.w, r0, v0
cmp r1.x, r1, c2.y, -c2.y
mad_pp r1.xyz, r2, -r1.x, r4
texld r3.zw, r0, s1
mad r0.xy, r1, r2.w, v0
texld r2.zw, r0, s1
mul r0.xy, r2.zwzw, c5
mad r2.x, -r0.z, c1, r1.w
mul r1.xy, r3.zwzw, c5
add r0.z, r1.x, r1.y
mad_sat r0.z, -r0, c0, r2.x
add r1.y, -r0.z, c2.w
pow r2, r1.y, c1.z
add r0.x, r0, r0.y
mad r1.x, -r1.z, c1, r1.w
mad_sat r0.x, -r0, c0.z, r1
add r0.y, -r0.x, c2.w
pow r1, r0.y, c1.z
mov r0.y, r2.x
add r1.y, r0.w, r0
add r0.y, r0.z, -c1
cmp r0.y, -r0, r0.w, r1
add r0.z, r0.y, r1.x
add r0.x, r0, -c1.y
cmp r0.x, -r0, r0.y, r0.z
mad oC0, -r0.x, c5.z, c5.x
"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 5 [_NoiseScale]
Vector 6 [_CameraDepthNormalsTexture_ST]
"3.0-!!ARBvp1.0
# 6 ALU
PARAM c[7] = { program.local[0],
		state.matrix.mvp,
		program.local[5..6] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[6], c[6].zwzw;
MUL result.texcoord[1].xy, vertex.texcoord[0], c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_NoiseScale]
Vector 5 [_CameraDepthNormalsTexture_ST]
"vs_3_0
; 6 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v1
mad o1.xy, v1, c5, c5.zwzw
mul o2.xy, v1, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ProjectionParams]
Vector 1 [_Params]
SetTexture 0 [_RandomTexture] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 486 ALU, 28 TEX
PARAM c[30] = { program.local[0..1],
		{ 2, 1, 3.5553999, 0 },
		{ 0.2448421, -0.1610962, 0.1289366, -1 },
		{ -1.7776999, 1, 0.30000001, 0.0039215689 },
		{ -0.3465451, -0.1654651, -0.67467582, 0.03846154 },
		{ 0.1932822, -0.36920989, -0.60605878 },
		{ 0.6389147, 0.1191014, -0.52712059 },
		{ -0.48002321, -0.18994731, 0.2398808 },
		{ 0.12803879, -0.56324202, 0.34192759 },
		{ -0.1365018, -0.25134161, 0.47093701 },
		{ -0.34797809, 0.47257659, -0.71968502 },
		{ 0.1841383, 0.1696993, -0.89362812 },
		{ 0.2792919, 0.2487278, -0.051853411 },
		{ -0.77863449, -0.38148519, -0.23912621 },
		{ 0.060396291, 0.24629, 0.45011759 },
		{ -0.1795662, -0.35438621, 0.079243474 },
		{ 0.06262707, -0.21286429, -0.036715619 },
		{ 0.8242752, 0.02434147, 0.060490981 },
		{ -0.2634767, 0.52779227, -0.1107446 },
		{ -0.1915639, -0.49734211, -0.31296289 },
		{ -0.27525371, 0.076259486, -0.1273409 },
		{ 0.53779137, 0.31121889, 0.426864 },
		{ 0.65801197, -0.43959719, -0.29193729 },
		{ -0.1108412, 0.2162839, 0.1336278 },
		{ 0.3149606, -0.1294581, 0.70445168 },
		{ -0.37908071, 0.1454145, 0.100605 },
		{ -0.41522461, 0.1320857, 0.70367342 },
		{ 0.059166811, 0.2201506, -0.1430302 },
		{ 0.2196607, 0.90326369, 0.2254677 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R5, fragment.texcoord[0], texture[1], 2D;
MUL R0.xyz, R5, c[2].zzww;
ADD R2.xyz, R0, c[4].xxyw;
TEX R0.xyz, fragment.texcoord[1], texture[0], 2D;
MAD R1.xyz, R0, c[2].x, -c[2].y;
DP3 R0.w, R2, R2;
RCP R0.x, R0.w;
MUL R0.w, R0.x, c[2].x;
DP3 R1.w, R1, c[28];
MUL R3.xyz, R1, R1.w;
MUL R5.xy, R5.zwzw, c[4].ywzw;
DP3 R0.y, R1, c[29];
MUL R0.xyz, R1, R0.y;
MUL R0.xyz, -R0, c[2].x;
ADD R1.w, R5.x, R5.y;
MUL R3.xyz, -R3, c[2].x;
MUL R2.xy, R0.w, R2;
ADD R2.z, R0.w, -c[2].y;
ADD R4.xyz, R0, c[29];
MUL R1.w, R1, c[0].z;
MOV R0.w, c[3];
DP3 R0.x, R2, R4;
CMP R2.w, R0.x, c[2].y, R0;
MUL R0.xyz, R2, c[4].z;
MAD R4.xyz, R4, -R2.w, R0;
ADD R3.xyz, R3, c[28];
DP3 R2.w, R2, R3;
CMP R3.w, R2, c[2].y, R0;
MAD R3.xyz, R3, -R3.w, R0;
RCP R2.w, R1.w;
MUL R2.w, R2, c[1].x;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
TEX R5.zw, R3, texture[1], 2D;
MUL R3.xy, R5.zwzw, c[4].ywzw;
TEX R6.zw, R4, texture[1], 2D;
MAD R3.w, -R4.z, c[1].x, R1;
DP3 R4.w, R1, c[26];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.z, -R3.x, c[0], R3;
MUL R3.xy, R6.zwzw, c[4].ywzw;
ADD R3.x, R3, R3.y;
MAD_SAT R3.x, -R3, c[0].z, R3.w;
ADD R3.y, -R3.x, c[2];
ADD R3.w, -R3.z, c[2].y;
POW R4.x, R3.w, c[1].z;
POW R3.y, R3.y, c[1].z;
ADD R3.x, R3, -c[1].y;
CMP R3.w, -R3.x, R3.y, c[2];
ADD R4.x, R3.w, R4;
ADD R3.y, R3.z, -c[1];
CMP R3.w, -R3.y, R4.x, R3;
DP3 R3.x, R1, c[27];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[27];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[26];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[25];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[24];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[25];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[24];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[23];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[22];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[23];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[22];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[21];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[20];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[21];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[20];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[19];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[18];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[19];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[18];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[17];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[16];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[17];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[16];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[15];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[14];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[15];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[14];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[13];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[12];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[13];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[12];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[11];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[10];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[11];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[10];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[9];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[8];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[9];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[8];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[7];
MUL R3.xyz, R1, R3.x;
MUL R4.xyz, -R3, c[2].x;
DP3 R4.w, R1, c[6];
MUL R3.xyz, R1, R4.w;
ADD R4.xyz, R4, c[7];
DP3 R4.w, R2, R4;
CMP R5.x, R4.w, c[2].y, R0.w;
MAD R4.xyz, R4, -R5.x, R0;
MAD R4.xy, R2.w, R4, fragment.texcoord[0];
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[6];
DP3 R4.w, R2, R3;
CMP R4.w, R4, c[2].y, R0;
MAD R3.xyz, R3, -R4.w, R0;
TEX R5.zw, R4, texture[1], 2D;
MUL R4.xy, R5.zwzw, c[4].ywzw;
MAD R3.xy, R2.w, R3, fragment.texcoord[0];
ADD R4.x, R4, R4.y;
MAD R4.z, -R4, c[1].x, R1.w;
MAD_SAT R4.x, -R4, c[0].z, R4.z;
TEX R4.zw, R3, texture[1], 2D;
MUL R3.xy, R4.zwzw, c[4].ywzw;
ADD R4.y, -R4.x, c[2];
ADD R3.x, R3, R3.y;
MAD R3.z, -R3, c[1].x, R1.w;
MAD_SAT R3.x, -R3, c[0].z, R3.z;
POW R3.y, R4.y, c[1].z;
ADD R3.z, R3.w, R3.y;
ADD R3.y, R4.x, -c[1];
CMP R3.z, -R3.y, R3, R3.w;
ADD R4.y, -R3.x, c[2];
ADD R3.y, R3.x, -c[1];
POW R4.y, R4.y, c[1].z;
ADD R3.w, R3.z, R4.y;
CMP R3.w, -R3.y, R3, R3.z;
DP3 R3.x, R1, c[5];
MUL R3.xyz, R1, R3.x;
DP3 R4.x, R1, c[3];
MUL R1.xyz, R1, R4.x;
MUL R3.xyz, -R3, c[2].x;
ADD R3.xyz, R3, c[5];
DP3 R4.x, R2, R3;
MUL R1.xyz, -R1, c[2].x;
ADD R1.xyz, R1, c[3];
CMP R4.y, R4.x, c[2], R0.w;
DP3 R4.x, R1, R2;
MAD R2.xyz, R3, -R4.y, R0;
CMP R0.w, R4.x, c[2].y, R0;
MAD R0.xyz, R1, -R0.w, R0;
MAD R2.xy, R2.w, R2, fragment.texcoord[0];
TEX R4.zw, R2, texture[1], 2D;
MUL R1.xy, R4.zwzw, c[4].ywzw;
MAD R0.xy, R0, R2.w, fragment.texcoord[0];
MAD R1.z, -R2, c[1].x, R1.w;
ADD R0.w, R1.x, R1.y;
MAD_SAT R0.w, -R0, c[0].z, R1.z;
TEX R2.zw, R0, texture[1], 2D;
MUL R0.xy, R2.zwzw, c[4].ywzw;
ADD R0.x, R0, R0.y;
ADD R1.x, -R0.w, c[2].y;
MAD R0.z, -R0, c[1].x, R1.w;
MAD_SAT R0.x, -R0, c[0].z, R0.z;
POW R0.y, R1.x, c[1].z;
ADD R1.x, -R0, c[2].y;
ADD R0.z, R3.w, R0.y;
ADD R0.y, R0.w, -c[1];
CMP R0.y, -R0, R0.z, R3.w;
POW R1.x, R1.x, c[1].z;
ADD R0.z, R0.y, R1.x;
ADD R0.x, R0, -c[1].y;
CMP R0.x, -R0, R0.z, R0.y;
MUL R0.x, -R0, c[5].w;
ADD result.color, R0.x, c[2].y;
END
# 486 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ProjectionParams]
Vector 1 [_Params]
SetTexture 0 [_RandomTexture] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"ps_3_0
; 506 ALU, 28 TEX
dcl_2d s0
dcl_2d s1
def c2, 2.00000000, -1.00000000, 0.30000001, 1.00000000
def c3, 0.24484210, -0.16109620, 0.12893660, 2.00000000
def c4, 3.55539989, 0.00000000, -1.77769995, 1.00000000
def c5, 1.00000000, 0.00392157, 0.03846154, 0
def c6, -0.34654510, -0.16546510, -0.67467582, 2.00000000
def c7, 0.19328220, -0.36920989, -0.60605878, 2.00000000
def c8, 0.63891470, 0.11910140, -0.52712059, 2.00000000
def c9, -0.48002321, -0.18994731, 0.23988080, 2.00000000
def c10, 0.12803879, -0.56324202, 0.34192759, 2.00000000
def c11, -0.13650180, -0.25134161, 0.47093701, 2.00000000
def c12, -0.34797809, 0.47257659, -0.71968502, 2.00000000
def c13, 0.18413830, 0.16969930, -0.89362812, 2.00000000
def c14, 0.27929190, 0.24872780, -0.05185341, 2.00000000
def c15, -0.77863449, -0.38148519, -0.23912621, 2.00000000
def c16, 0.06039629, 0.24629000, 0.45011759, 2.00000000
def c17, -0.17956620, -0.35438621, 0.07924347, 2.00000000
def c18, 0.06262707, -0.21286429, -0.03671562, 2.00000000
def c19, 0.82427520, 0.02434147, 0.06049098, 2.00000000
def c20, -0.26347670, 0.52779227, -0.11074460, 2.00000000
def c21, -0.19156390, -0.49734211, -0.31296289, 2.00000000
def c22, -0.27525371, 0.07625949, -0.12734090, 2.00000000
def c23, 0.53779137, 0.31121889, 0.42686400, 2.00000000
def c24, 0.65801197, -0.43959719, -0.29193729, 2.00000000
def c25, -0.11084120, 0.21628390, 0.13362780, 2.00000000
def c26, 0.31496060, -0.12945810, 0.70445168, 2.00000000
def c27, -0.37908071, 0.14541450, 0.10060500, 2.00000000
def c28, -0.41522461, 0.13208570, 0.70367342, 2.00000000
def c29, 0.05916681, 0.22015060, -0.14303020, 2.00000000
def c30, 0.21966070, 0.90326369, 0.22546770, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
texld r0.xyz, v1, s0
mad r2.xyz, r0, c2.x, c2.y
texld r5, v0, s1
mad r1.xyz, r5, c4.xxyw, c4.zzww
dp3 r0.w, r1, r1
rcp r0.x, r0.w
mul r0.w, r0.x, c2.x
dp3 r0.y, r2, c30
mul r0.xyz, r2, r0.y
mul r1.xy, r0.w, r1
add r1.z, r0.w, c2.y
mad r0.xyz, -r0, c30.w, c30
dp3 r0.w, r1, r0
cmp r1.w, r0, c2.y, -c2.y
mul r4.xyz, r1, c2.z
mad_pp r3.xyz, r0, -r1.w, r4
dp3 r0.w, r2, c29
mul r0.xyz, r2, r0.w
mul r5.xy, r5.zwzw, c5
add r0.w, r5.x, r5.y
mul r1.w, r0, c0.z
mad r0.xyz, -r0, c29.w, c29
dp3 r2.w, r1, r0
cmp r2.w, r2, c2.y, -c2.y
mad_pp r0.xyz, r0, -r2.w, r4
rcp r0.w, r1.w
mul r2.w, r0, c1.x
mad r3.xy, r2.w, r3, v0
mad r0.xy, r2.w, r0, v0
texld r5.zw, r0, s1
mul r0.xy, r5.zwzw, c5
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r4.w, -r0.x, c0.z, r0.z
texld r6.zw, r3, s1
mul r0.xy, r6.zwzw, c5
mad r0.z, -r3, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.x, -r0, c0.z, r0.z
add r3.x, -r4.w, c2.w
pow r0, r3.x, c1.z
add r5.y, -r5.x, c2.w
pow r3, r5.y, c1.z
mov r0.w, r0.x
mov r0.y, r3.x
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, c4.y, r0.y
add r0.w, r0.z, r0
add r0.y, r4.w, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c28
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c27
mad r3.xyz, -r0, c28.w, c28
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c27.w, c27
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c26
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c25
mad r3.xyz, -r0, c26.w, c26
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c25.w, c25
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c24
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c23
mad r3.xyz, -r0, c24.w, c24
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c23.w, c23
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c22
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c21
mad r3.xyz, -r0, c22.w, c22
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c21.w, c21
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c20
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c19
mad r3.xyz, -r0, c20.w, c20
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c19.w, c19
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c18
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c17
mad r3.xyz, -r0, c18.w, c18
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c17.w, c17
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c16
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c15
mad r3.xyz, -r0, c16.w, c16
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c15.w, c15
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c14
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c13
mad r3.xyz, -r0, c14.w, c14
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c13.w, c13
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c12
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c11
mad r3.xyz, -r0, c12.w, c12
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c11.w, c11
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c10
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c9
mad r3.xyz, -r0, c10.w, c10
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
texld r5.zw, r3, s1
mad r0.xyz, -r0, c9.w, c9
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
pow r3, r0.w, c1.z
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r4.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c8
mul r0.xyz, r2, r0.x
dp3 r0.w, r2, c7
mad r3.xyz, -r0, c8.w, c8
mul r0.xyz, r2, r0.w
dp3 r0.w, r1, r3
cmp r3.w, r0, c2.y, -c2.y
mad_pp r3.xyz, r3, -r3.w, r4
mad r3.xy, r2.w, r3, v0
mad r0.xyz, -r0, c7.w, c7
dp3 r0.w, r1, r0
cmp r0.w, r0, c2.y, -c2.y
mad_pp r0.xyz, r0, -r0.w, r4
texld r5.zw, r3, s1
mul r3.xy, r5.zwzw, c5
mad r3.z, -r3, c1.x, r1.w
add r0.w, r3.x, r3.y
mad_sat r5.x, -r0.w, c0.z, r3.z
mad r0.xy, r2.w, r0, v0
texld r3.zw, r0, s1
mul r0.xy, r3.zwzw, c5
add r0.w, -r5.x, c2
mad r0.z, -r0, c1.x, r1.w
add r0.x, r0, r0.y
pow r3, r0.w, c1.z
mad_sat r5.y, -r0.x, c0.z, r0.z
add r3.y, -r5, c2.w
pow r0, r3.y, c1.z
mov r0.y, r3.x
mov r0.w, r0.x
dp3 r3.x, r2, c3
add r0.y, r4.w, r0
add r0.x, r5, -c1.y
cmp r0.z, -r0.x, r4.w, r0.y
add r0.w, r0.z, r0
add r0.y, r5, -c1
cmp r0.w, -r0.y, r0.z, r0
dp3 r0.x, r2, c6
mul r0.xyz, r2, r0.x
mul r2.xyz, r2, r3.x
mad r0.xyz, -r0, c6.w, c6
dp3 r3.x, r1, r0
mad r2.xyz, -r2, c3.w, c3
dp3 r1.x, r2, r1
cmp r3.x, r3, c2.y, -c2.y
mad_pp r0.xyz, r0, -r3.x, r4
mad r0.xy, r2.w, r0, v0
cmp r1.x, r1, c2.y, -c2.y
mad_pp r1.xyz, r2, -r1.x, r4
texld r3.zw, r0, s1
mad r0.xy, r1, r2.w, v0
texld r2.zw, r0, s1
mul r0.xy, r2.zwzw, c5
mad r2.x, -r0.z, c1, r1.w
mul r1.xy, r3.zwzw, c5
add r0.z, r1.x, r1.y
mad_sat r0.z, -r0, c0, r2.x
add r1.y, -r0.z, c2.w
pow r2, r1.y, c1.z
add r0.x, r0, r0.y
mad r1.x, -r1.z, c1, r1.w
mad_sat r0.x, -r0, c0.z, r1
add r0.y, -r0.x, c2.w
pow r1, r0.y, c1.z
mov r0.y, r2.x
add r1.y, r0.w, r0
add r0.y, r0.z, -c1
cmp r0.y, -r0, r0.w, r1
add r0.z, r0.y, r1.x
add r0.x, r0, -c1.y
cmp r0.x, -r0, r0.y, r0.z
mad oC0, -r0.x, c5.z, c5.x
"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 5 [_CameraDepthNormalsTexture_ST]
"3.0-!!ARBvp1.0
# 5 ALU
PARAM c[6] = { program.local[0],
		state.matrix.mvp,
		program.local[5] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[5], c[5].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 5 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_CameraDepthNormalsTexture_ST]
"vs_3_0
; 5 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_position0 v0
dcl_texcoord0 v1
mad o1.xy, v1, c4, c4.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ProjectionParams]
Vector 1 [_TexelOffsetScale]
SetTexture 0 [_SSAO] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 150 ALU, 18 TEX
PARAM c[4] = { program.local[0..1],
		{ 5, 0.099975586, 1, 0.0039215689 },
		{ 0.2, 4, 2, 3 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
ADD R4.xy, fragment.texcoord[0], c[1];
TEX R0, R4, texture[1], 2D;
TEX R3, fragment.texcoord[0], texture[1], 2D;
MUL R1.xy, R0.zwzw, c[2].zwzw;
MUL R0.zw, R3, c[2];
ADD R0.xy, R3, -R0;
ABS R0.xy, R0;
ADD R0.x, R0, R0.y;
ADD R0.y, R1.x, R1;
MOV R1.xyz, c[3].yzww;
ADD R6.w, R0.z, R0;
MAD R4.zw, R1.y, c[1].xyxy, fragment.texcoord[0].xyxy;
MAD R3.zw, R1.z, c[1].xyxy, fragment.texcoord[0].xyxy;
MAD R2.zw, R1.x, c[1].xyxy, fragment.texcoord[0].xyxy;
MAD R5.xy, R1.y, -c[1], fragment.texcoord[0];
ADD R0.y, R6.w, -R0;
SLT R1.w, R0.x, c[2].y;
ABS R0.x, R0.y;
MUL R0.x, R0, c[0].z;
SLT R2.x, R0, c[3];
TEX R0, R4.zwzw, texture[1], 2D;
MUL R1.w, R1, R2.x;
MUL R0.zw, R0, c[2];
ADD R0.z, R0, R0.w;
ADD R0.xy, R3, -R0;
ABS R0.xy, R0;
ADD R0.x, R0, R0.y;
ADD R0.z, R6.w, -R0;
ABS R0.z, R0;
MUL R0.y, R0.z, c[0].z;
MUL R6.x, R1.w, c[3].y;
SLT R0.x, R0, c[2].y;
SLT R0.y, R0, c[3].x;
MUL R1.w, R0.x, R0.y;
TEX R0, R3.zwzw, texture[1], 2D;
MUL R6.y, R1.w, c[3].w;
MUL R0.zw, R0, c[2];
ADD R0.z, R0, R0.w;
ADD R0.xy, R3, -R0;
ABS R0.xy, R0;
ADD R0.x, R0, R0.y;
ADD R0.z, R6.w, -R0;
ABS R0.z, R0;
MUL R0.y, R0.z, c[0].z;
SLT R0.x, R0, c[2].y;
SLT R0.y, R0, c[3].x;
MUL R2.x, R0, R0.y;
TEX R0, R2.zwzw, texture[1], 2D;
MUL R6.z, R2.x, c[3];
MUL R0.zw, R0, c[2];
ADD R0.z, R0, R0.w;
ADD R0.xy, R3, -R0;
ABS R0.xy, R0;
ADD R0.x, R0, R0.y;
ADD R1.w, R6.x, R6.y;
ADD R0.z, R6.w, -R0;
ABS R0.z, R0;
MUL R0.y, R0.z, c[0].z;
SLT R0.x, R0, c[2].y;
SLT R0.y, R0, c[3].x;
MUL R7.x, R0, R0.y;
ADD R2.xy, fragment.texcoord[0], -c[1];
TEX R0, R2, texture[1], 2D;
MUL R0.zw, R0, c[2];
ADD R0.z, R0, R0.w;
ADD R0.xy, R3, -R0;
ABS R0.xy, R0;
ADD R0.x, R0, R0.y;
ADD R0.z, R6.w, -R0;
ADD R1.w, R6.z, R1;
SLT R5.z, R0.x, c[2].y;
ABS R0.y, R0.z;
MUL R0.x, R0.y, c[0].z;
SLT R1.y, R0.x, c[3].x;
TEX R0, R5, texture[1], 2D;
MUL R0.zw, R0, c[2];
ADD R0.z, R0, R0.w;
MUL R1.y, R5.z, R1;
ADD R0.xy, R3, -R0;
ABS R0.xy, R0;
ADD R0.x, R0, R0.y;
ADD R0.z, R6.w, -R0;
ABS R0.z, R0;
MUL R0.z, R0, c[0];
ADD R1.w, R7.x, R1;
MUL R1.y, R1, c[3];
ADD R5.z, R1.y, R1.w;
SLT R0.y, R0.z, c[3].x;
SLT R0.x, R0, c[2].y;
MUL R0.x, R0, R0.y;
MUL R7.y, R0.x, c[3].w;
MAD R1.zw, R1.z, -c[1].xyxy, fragment.texcoord[0].xyxy;
TEX R0, R1.zwzw, texture[1], 2D;
MUL R0.zw, R0, c[2];
ADD R0.z, R0, R0.w;
ADD R7.z, R7.y, R5;
ADD R0.xy, R3, -R0;
ABS R0.xy, R0;
ADD R0.x, R0, R0.y;
ADD R0.z, R6.w, -R0;
SLT R7.w, R0.x, c[2].y;
ABS R0.y, R0.z;
MAD R5.zw, R1.x, -c[1].xyxy, fragment.texcoord[0].xyxy;
MUL R0.x, R0.y, c[0].z;
SLT R1.x, R0, c[3];
TEX R0, R5.zwzw, texture[1], 2D;
MUL R0.zw, R0, c[2];
MUL R1.x, R7.w, R1;
MUL R7.w, R1.x, c[3].z;
ADD R0.w, R0.z, R0;
ADD R0.xy, R3, -R0;
ABS R0.xy, R0;
ADD R0.x, R0, R0.y;
ADD R0.w, R6, -R0;
ABS R0.w, R0;
MUL R0.w, R0, c[0].z;
ADD R0.z, R7.w, R7;
SLT R0.y, R0.w, c[3].x;
SLT R0.x, R0, c[2].y;
MUL R0.y, R0.x, R0;
ADD R0.x, R0.y, R0.z;
ADD R0.z, R0.x, c[2].x;
TEX R0.x, R4.zwzw, texture[0], 2D;
MUL R3.x, R0, R6.y;
TEX R1.x, R4, texture[0], 2D;
MUL R0.w, R1.x, R6.x;
TEX R0.x, fragment.texcoord[0], texture[0], 2D;
MUL R0.x, R0, c[2];
ADD R0.x, R0, R0.w;
ADD R0.w, R0.x, R3.x;
TEX R0.x, R3.zwzw, texture[0], 2D;
TEX R1.x, R2.zwzw, texture[0], 2D;
MUL R0.x, R0, R6.z;
ADD R0.x, R0.w, R0;
MUL R1.x, R1, R7;
ADD R0.w, R0.x, R1.x;
TEX R0.x, R2, texture[0], 2D;
TEX R1.x, R5, texture[0], 2D;
MUL R0.x, R0, R1.y;
ADD R0.x, R0.w, R0;
MUL R1.x, R1, R7.y;
ADD R0.w, R0.x, R1.x;
TEX R0.x, R1.zwzw, texture[0], 2D;
TEX R1.x, R5.zwzw, texture[0], 2D;
MUL R0.x, R0, R7.w;
RCP R0.z, R0.z;
MUL R0.y, R1.x, R0;
ADD R0.x, R0.w, R0;
ADD R0.x, R0, R0.y;
MUL result.color, R0.x, R0.z;
END
# 150 instructions, 8 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ProjectionParams]
Vector 1 [_TexelOffsetScale]
SetTexture 0 [_SSAO] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"ps_3_0
; 50 ALU, 6 TEX, 10 FLOW
dcl_2d s0
dcl_2d s1
def c2, 5.00000000, 0.00000000, 1.00000000, 4.00000000
defi i0, 4, 0, 1, 0
def c3, -0.09997559, 1.00000000, 0.00392157, -0.20000000
dcl_texcoord0 v0.xy
texld r0.x, v0, s0
texld r1, v0, s1
mul r3.x, r0, c2
mov_pp r3.y, c2.x
mov r3.z, c2.y
loop aL, i0
add r3.w, -r3.z, c2
add r3.z, r3, c2
mad r2.xy, r3.z, c1, v0
texld r0, r2, s1
mul r2.zw, r0, c3.xyyz
mul r0.zw, r1, c3.xyyz
add_pp r0.xy, r1, -r0
abs_pp r0.xy, r0
add_pp r0.x, r0, r0.y
add_pp r0.x, r0, c3
add r2.z, r2, r2.w
add r0.z, r0, r0.w
add r0.z, r0, -r2
abs r0.z, r0
mul r0.z, r0, c0
add r0.y, r0.z, c3.w
cmp r0.y, r0, c2, c2.z
cmp_pp r0.x, r0, c2.y, c2.z
mul_pp r0.x, r0, r0.y
mul_pp r0.y, r3.w, r0.x
texld r0.x, r2, s0
mul r0.x, r0, r0.y
add_pp r3.x, r3, r0
add_pp r3.y, r0, r3
endloop
mov r3.z, c2.y
loop aL, i0
add r3.w, -r3.z, c2
add r3.z, r3, c2
mad r2.xy, -r3.z, c1, v0
texld r0, r2, s1
mul r2.zw, r0, c3.xyyz
mul r0.zw, r1, c3.xyyz
add_pp r0.xy, r1, -r0
abs_pp r0.xy, r0
add_pp r0.x, r0, r0.y
add_pp r0.x, r0, c3
add r2.z, r2, r2.w
add r0.z, r0, r0.w
add r0.z, r0, -r2
abs r0.z, r0
mul r0.z, r0, c0
add r0.y, r0.z, c3.w
cmp r0.y, r0, c2, c2.z
cmp_pp r0.x, r0, c2.y, c2.z
mul_pp r0.x, r0, r0.y
mul_pp r0.y, r3.w, r0.x
texld r0.x, r2, s0
mul r0.x, r0, r0.y
add_pp r3.x, r3, r0
add_pp r3.y, r0, r3
endloop
rcp_pp r0.x, r3.y
mul_pp oC0, r3.x, r0.x
"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
"!!ARBvp1.0
# 10 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		state.matrix.texture[0],
		state.matrix.texture[1] };
TEMP R0;
MOV R0.zw, c[0].x;
MOV R0.xy, vertex.texcoord[0];
DP4 result.texcoord[0].y, R0, c[6];
DP4 result.texcoord[0].x, R0, c[5];
DP4 result.texcoord[1].y, R0, c[10];
DP4 result.texcoord[1].x, R0, c[9];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 10 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Matrix 8 [glstate_matrix_texture1]
"vs_2_0
; 10 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.zw, c12.x
mov r0.xy, v1
dp4 oT0.y, r0, c5
dp4 oT0.x, r0, c4
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_Params]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SSAO] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 5 ALU, 2 TEX
PARAM c[1] = { program.local[0] };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.x, fragment.texcoord[1], texture[1], 2D;
POW R1.x, R1.x, c[0].w;
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 5 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_Params]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SSAO] 2D
"ps_2_0
; 6 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl t0.xy
dcl t1.xy
texld r2, t1, s1
texld r1, t0, s0
pow_pp r0.x, r2.x, c0.w
mov_pp r0.w, r1
mul_pp r0.xyz, r1, r0.x
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}