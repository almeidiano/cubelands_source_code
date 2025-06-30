//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/SeparableWeightedBlur" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "" {}
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
Vector 5 [offsets]
"!!ARBvp1.0
# 10 ALU
PARAM c[7] = { { 2, -2, 3, -3 },
		state.matrix.mvp,
		program.local[5],
		{ 1, -1 } };
TEMP R0;
TEMP R1;
MOV R1, c[0];
MOV R0.xy, c[6];
MAD result.texcoord[1], R0.xxyy, c[5].xyxy, vertex.texcoord[0].xyxy;
MAD result.texcoord[2], R1.xxyy, c[5].xyxy, vertex.texcoord[0].xyxy;
MAD result.texcoord[3], R1.zzww, c[5].xyxy, vertex.texcoord[0].xyxy;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 10 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [offsets]
"vs_2_0
; 11 ALU
def c5, 1.00000000, -1.00000000, 2.00000000, -2.00000000
def c6, 3.00000000, -3.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xy, c4
mad oT1, c5.xxyy, r0.xyxy, v1.xyxy
mov r0.xy, c4
mov r0.zw, c4.xyxy
mad oT2, c5.zzww, r0.xyxy, v1.xyxy
mad oT3, c6.xxyy, r0.zwzw, v1.xyxy
mov oT0.xy, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 7 TEX
PARAM c[2] = { { 0.1, 0.15000001, 0.40000001, 0.050000001 },
		{ 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEX R6, fragment.texcoord[1], texture[0], 2D;
TEX R5, fragment.texcoord[0], texture[0], 2D;
TEX R0, fragment.texcoord[3].zwzw, texture[0], 2D;
TEX R1, fragment.texcoord[3], texture[0], 2D;
TEX R2, fragment.texcoord[2].zwzw, texture[0], 2D;
TEX R3, fragment.texcoord[2], texture[0], 2D;
TEX R4, fragment.texcoord[1].zwzw, texture[0], 2D;
MUL R7.y, R6.w, c[0];
MUL R7.x, R5.w, c[0].z;
MUL R6, R7.y, R6;
MUL R5, R7.x, R5;
ADD R5, R5, R6;
MUL R6.x, R4.w, c[0].y;
MUL R6.y, R3.w, c[0].x;
MUL R4, R6.x, R4;
ADD R4, R5, R4;
MUL R3, R6.y, R3;
ADD R3, R4, R3;
MUL R4.x, R2.w, c[0];
MUL R4.y, R1.w, c[0].w;
MUL R2, R4.x, R2;
ADD R2, R3, R2;
MUL R1, R4.y, R1;
ADD R1, R2, R1;
MUL R2.z, R0.w, c[0].w;
MUL R3, R2.z, R0;
MOV R4.z, R2;
DP3 R2.x, R4, c[1].x;
MOV R7.w, R6.y;
MOV R7.z, R6.x;
DP4 R2.y, R7, c[1].x;
ADD R2.x, R2.y, R2;
RCP R0.x, R2.x;
ADD R1, R1, R3;
MUL result.color, R1, R0.x;
END
# 35 instructions, 8 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 38 ALU, 7 TEX
dcl_2d s0
def c0, 0.10000000, 0.15000001, 0.40000001, 0.05000000
def c1, 1.00000000, 0, 0, 0
dcl t0.xy
dcl t1
dcl t2
dcl t3
texld r4, t3, s0
texld r6, t2, s0
texld r7, t1, s0
mov r0.y, t1.w
mov r0.x, t1.z
mov r1.y, t3.w
mov r1.x, t3.z
mov r2.xy, r1
mov r1.y, t2.w
mov r1.x, t2.z
texld r5, r2, s0
texld r2, r0, s0
texld r3, r1, s0
texld r1, t0, s0
mul r0.x, r7.w, c0.y
mul r9.x, r1.w, c0.z
mul r1, r9.x, r1
mul r7, r0.x, r7
add_pp r7, r1, r7
mul r1.x, r2.w, c0.y
mul r8, r1.x, r2
mul r2.x, r6.w, c0
add_pp r7, r7, r8
mul r6, r2.x, r6
add_pp r6, r7, r6
mul r8.x, r3.w, c0
mul r7, r8.x, r3
mul r3.x, r4.w, c0.w
mul r4, r3.x, r4
add_pp r6, r6, r7
add_pp r6, r6, r4
mul r4.x, r5.w, c0.w
mov_pp r9.z, r1.x
mul r1, r4.x, r5
mov_pp r8.y, r3.x
mov_pp r8.z, r4.x
dp3_pp r3.x, r8, c1.x
mov_pp r9.w, r2.x
mov_pp r9.y, r0.x
dp4_pp r0.x, r9, c1.x
add_pp r0.x, r0, r3
rcp_pp r0.x, r0.x
add_pp r1, r6, r1
mul_pp r0, r1, r0.x
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}