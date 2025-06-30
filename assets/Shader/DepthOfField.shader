//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/DepthOfField" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "" {}
 _LowRez ("_LowRez", 2D) = "" {}
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
Vector 5 [_MainTex_ST]
Vector 6 [_LowRez_ST]
"!!ARBvp1.0
# 6 ALU
PARAM c[7] = { program.local[0],
		state.matrix.mvp,
		program.local[5..6] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[5], c[5].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[6], c[6].zwzw;
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
Vector 4 [_MainTex_TexelSize]
Vector 5 [_MainTex_ST]
Vector 6 [_LowRez_ST]
"vs_2_0
; 15 ALU
def c7, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.x, c7
slt r0.x, c4.y, r0
max r0.x, -r0, r0
slt r0.z, c7.x, r0.x
mad r0.xy, v1, c6, c6.zwzw
add r0.w, -r0.z, c7.y
mul r0.w, r0.y, r0
add r0.y, -r0, c7
mad oT1.y, r0.z, r0, r0.w
mad oT0.xy, v1, c5, c5.zwzw
mov oT1.x, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_MainTex_TexelSize]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LowRez] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 57 ALU, 9 TEX
PARAM c[8] = { program.local[0],
		{ 1.4003906, 1.0057373, 1.2005615, 0 },
		{ 1, -1.3253174, 0.61138916, 0 },
		{ 0.77075195, -1.1185303, 0 },
		{ -0.73400879, -1.0783691, 0 },
		{ -1.1732178, -0.31488037, 0 },
		{ -0.070175171, 0.93823242, 0 },
		{ 0.92370605, -0.15028381, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEMP R9;
TEMP R10;
TEX R10.xyz, fragment.texcoord[1], texture[1], 2D;
MOV R1.xy, c[5];
MAD R5.xy, R1, c[0], fragment.texcoord[0];
MOV R1.zw, c[4].xyxy;
MAD R4.xy, R1.zwzw, c[0], fragment.texcoord[0];
MOV R1.xy, c[3];
MAD R3.xy, R1, c[0], fragment.texcoord[0];
MOV R1.zw, c[2].xyyz;
MAD R2.xy, R1.zwzw, c[0], fragment.texcoord[0];
MOV R0.xy, c[7];
MAD R0.xy, R0, c[0], fragment.texcoord[0];
MOV R0.zw, c[6].xyxy;
MAD R0.zw, R0, c[0].xyxy, fragment.texcoord[0].xyxy;
MOV R1.xy, c[1].yzzw;
MAD R1.xy, R1, c[0], fragment.texcoord[0];
MOV R9.w, c[2].x;
MOV R8.w, c[2].x;
MOV result.color.w, c[2].x;
TEX R6, R0.zwzw, texture[0], 2D;
TEX R7, R0, texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, R1, texture[0], 2D;
TEX R2, R2, texture[0], 2D;
TEX R3, R3, texture[0], 2D;
TEX R4, R4, texture[0], 2D;
TEX R5, R5, texture[0], 2D;
MOV R9.xyz, R0;
MOV R8.xyz, R0;
MAD R8, R0.w, R9, R8;
MOV R9.xyz, R7;
MOV R9.w, c[2].x;
MAD R7, R9, R7.w, R8;
MOV R8.xyz, R6;
MOV R8.w, c[2].x;
MAD R6, R8, R6.w, R7;
MOV R7.xyz, R5;
MOV R7.w, c[2].x;
MAD R5, R7, R5.w, R6;
MOV R6.xyz, R4;
MOV R6.w, c[2].x;
MAD R4, R6, R4.w, R5;
MOV R5.xyz, R3;
MOV R5.w, c[2].x;
MAD R3, R5, R3.w, R4;
MOV R4.xyz, R2;
MOV R4.w, c[2].x;
MAD R2, R4, R2.w, R3;
MOV R3.xyz, R1;
MOV R3.w, c[2].x;
MAD R1, R3, R1.w, R2;
RCP R1.w, R1.w;
MAD R2.xyz, -R1, R1.w, R10;
MUL R3.xyz, R1, R1.w;
MUL_SAT R1.x, R0.w, c[1];
MAD R1.xyz, R1.x, R2, R3;
ADD R1.xyz, -R0, R1;
MAD result.color.xyz, R0.w, R1, R0;
END
# 57 instructions, 11 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_MainTex_TexelSize]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LowRez] 2D
"ps_2_0
; 55 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
def c1, 1.40039063, 1.00573730, 1.20056152, 1.00000000
def c2, -1.32531738, 0.61138916, 0.77075195, -1.11853027
def c3, -0.73400879, -1.07836914, -1.17321777, -0.31488037
def c4, -0.07017517, 0.93823242, 0.92370605, -0.15028381
dcl t0.xy
dcl t1.xy
texld r10, t1, s1
texld r9, t0, s0
mov r5.xy, c0
mad r5.xy, c2, r5, t0
mov r6.xy, c0
mad r6.xy, c1.yzxw, r6, t0
mov r1.xy, c0
mov r3.xy, c0
mov_pp r1.w, c1
mov r0.x, c4.z
mov r0.y, c4.w
mad r0.xy, r0, r1, t0
mov r1.x, c3.z
mov r1.y, c3.w
mov r2.xy, c0
mad r2.xy, r1, r2, t0
mov r1.x, c2.z
mov r1.y, c2.w
mad r4.xy, r1, r3, t0
mov r1.xy, c0
mov r3.xy, c0
mad r1.xy, c4, r1, t0
mad r3.xy, c3, r3, t0
mov_pp r0.w, c1
texld r8, r6, s0
texld r7, r5, s0
texld r6, r4, s0
texld r5, r3, s0
texld r4, r2, s0
texld r3, r1, s0
texld r2, r0, s0
mov_pp r1.xyz, r9
mov_pp r0.xyz, r9
mad_pp r0, r9.w, r1, r0
mov_pp r1.xyz, r2
mov_pp r1.w, c1
mad_pp r0, r1, r2.w, r0
mov_pp r1.xyz, r3
mov_pp r1.w, c1
mad_pp r0, r1, r3.w, r0
mov_pp r1.xyz, r4
mov_pp r1.w, c1
mad_pp r0, r1, r4.w, r0
mov_pp r1.xyz, r5
mov_pp r1.w, c1
mad_pp r0, r1, r5.w, r0
mov_pp r1.xyz, r6
mov_pp r1.w, c1
mad_pp r0, r1, r6.w, r0
mov_pp r1.xyz, r7
mov_pp r1.w, c1
mad_pp r0, r1, r7.w, r0
mov_pp r1.xyz, r8
mov_pp r1.w, c1
mad_pp r1, r1, r8.w, r0
rcp_pp r0.x, r1.w
mad_pp r2.xyz, -r1, r0.x, r10
mul_pp r1.xyz, r1, r0.x
mul_pp_sat r0.x, r9.w, c1
mad_pp r0.xyz, r0.x, r2, r1
add_pp r0.xyz, -r9, r0
mov_pp r0.w, c1
mad_pp r0.xyz, r9.w, r0, r9
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}