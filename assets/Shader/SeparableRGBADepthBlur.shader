//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/SeparableRGBADepthBlur" {
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
# 27 ALU, 7 TEX
PARAM c[6] = { { 0.40000001, 0.0015686275, 6.1514802e-006, 2.490949e-009 },
		{ 0.15000001, 0.00058823533, 2.3068051e-006, 9.341059e-010 },
		{ 0.1, 0.00039215689, 1.53787e-006, 6.2273725e-010 },
		{ 0.050000001, 0.00019607844, 7.6893502e-007, 3.1136863e-010 },
		{ 1, 0, 0.0039215689 },
		{ 1, 255, 65025, 1.6058138e+008 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[1], texture[0], 2D;
TEX R2, fragment.texcoord[1].zwzw, texture[0], 2D;
TEX R6, fragment.texcoord[3].zwzw, texture[0], 2D;
TEX R5, fragment.texcoord[3], texture[0], 2D;
TEX R4, fragment.texcoord[2].zwzw, texture[0], 2D;
TEX R3, fragment.texcoord[2], texture[0], 2D;
DP4 R0.x, R0, c[0];
DP4 R1.x, R1, c[1];
ADD R0.x, R0, R1;
DP4 R2.x, R2, c[1];
DP4 R0.y, R3, c[2];
ADD R0.x, R0, R2;
ADD R0.x, R0, R0.y;
DP4 R0.z, R4, c[2];
ADD R0.x, R0, R0.z;
DP4 R0.y, R5, c[3];
DP4 R0.z, R6, c[3];
ADD R0.x, R0, R0.y;
ADD R0.x, R0, R0.z;
MUL R1, R0.x, c[5];
SLT R0.x, c[4], R0;
FRC R1, R1;
ABS R0.x, R0;
MAD R1, -R1.yzww, c[4].z, R1;
CMP R0.x, -R0, c[4].y, c[4];
CMP result.color, -R0.x, R1, c[4].x;
END
# 27 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 30 ALU, 7 TEX
dcl_2d s0
def c0, 0.40000001, 0.00156863, 0.00000615, 0.00000000
def c1, 0.15000001, 0.00058824, 0.00000231, 0.00000000
def c2, 0.10000000, 0.00039216, 0.00000154, 0.00000000
def c3, 0.05000000, 0.00019608, 0.00000077, 0.00000000
def c4, 1.00000000, 0.00000000, 0.00392157, 0
def c5, 1.00000000, 255.00000000, 65025.00000000, 160581376.00000000
dcl t0.xy
dcl t1
dcl t2
dcl t3
texld r4, t2, s0
texld r6, t0, s0
texld r5, t1, s0
mov r2.y, t2.w
mov r2.x, t2.z
mov r3.xy, r2
mov r0.y, t1.w
mov r0.x, t1.z
mov r1.y, t3.w
mov r1.x, t3.z
dp4 r5.x, r5, c1
dp4 r6.x, r6, c0
add_pp r5.x, r6, r5
dp4 r4.x, r4, c2
texld r1, r1, s0
texld r2, t3, s0
texld r3, r3, s0
texld r0, r0, s0
dp4 r0.x, r0, c1
add_pp r0.x, r5, r0
dp4 r2.x, r2, c3
dp4 r1.x, r1, c3
dp4 r3.x, r3, c2
add_pp r0.x, r0, r4
add_pp r0.x, r0, r3
add_pp r0.x, r0, r2
add_pp r0.x, r0, r1
mul r1, r0.x, c5
frc r1, r1
add_pp r0.x, -r0, c4
cmp_pp r0.x, r0, c4.y, c4
mov r2.z, -r1.w
mov r2.xyw, -r1.yzxw
mad r1, r2, c4.z, r1
abs_pp r0.x, r0
cmp_pp r0, -r0.x, r1, c4.x
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}