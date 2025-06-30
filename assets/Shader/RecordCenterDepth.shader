//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/RecordCenterDepth" {
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
"!!ARBvp1.0
# 8 ALU
PARAM c[9] = { { 0 },
		state.matrix.mvp,
		state.matrix.texture[0] };
TEMP R0;
MOV R0.zw, c[0].x;
MOV R0.xy, vertex.texcoord[0];
DP4 result.texcoord[0].y, R0, c[6];
DP4 result.texcoord[0].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 8 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
"vs_2_0
; 8 ALU
def c8, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.zw, c8.x
mov r0.xy, v1
dp4 oT0.y, r0, c5
dp4 oT0.x, r0, c4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ZBufferParams]
Vector 1 [_CameraDepthTexture_TexelSize]
Float 2 [deltaTime]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 25 ALU, 4 TEX
PARAM c[6] = { program.local[0..2],
		{ 0.33333334, 1, 0, 0.5 },
		{ 0.99989998, 0.0039215689 },
		{ 1, 255, 65025, 1.6058138e+008 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2.x, c[3].w, texture[0], 2D;
MOV R0.x, c[3].w;
ADD R1.zw, R0.x, c[1].xyxy;
ADD R1.xy, R0.x, -c[1];
MOV_SAT R3.y, c[2].x;
TEX R0, c[3].w, texture[1], 2D;
TEX R3.x, R1.zwzw, texture[0], 2D;
TEX R1.x, R1, texture[0], 2D;
ADD R1.y, R2.x, R3.x;
ADD R1.x, R1.y, R1;
MUL R1.x, R1, c[0];
MUL R1.x, R1, c[3];
ADD R1.x, R1, c[0].y;
RCP R3.x, R1.x;
MUL R1, R3.x, c[5];
FRC R1, R1;
MAD R1, -R1.yzww, c[4].y, R1;
ADD R1, R1, -R0;
MAD R2, R3.y, R1, R0;
ADD R1, -R0, c[3].y;
SLT R3.x, c[4], R3;
MAD R0, R3.y, R1, R0;
ABS R3.x, R3;
CMP R1.x, -R3, c[3].z, c[3].y;
CMP result.color, -R1.x, R2, R0;
END
# 25 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Vector 1 [_CameraDepthTexture_TexelSize]
Float 2 [deltaTime]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_MainTex] 2D
"ps_2_0
; 27 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.50000000, 0.33333334, 0.99989998, 1.00000000
def c4, 0.00000000, 1.00000000, 0.00392157, 0
def c5, 1.00000000, 255.00000000, 65025.00000000, 160581376.00000000
mov r1.xy, c1
mov r0.xy, c1
add r1.xy, c3.x, r1
add r0.xy, c3.x, -r0
mov r2.xy, c3.x
mov r3.xy, c3.x
texld r3, r3, s0
texld r0, r0, s0
texld r1, r1, s0
texld r2, r2, s1
add r1.x, r3, r1
add r0.x, r1, r0
mul r0.x, r0, c0
mul r0.x, r0, c3.y
add r0.x, r0, c0.y
rcp r0.x, r0.x
mul r1, r0.x, c5
frc r3, r1
add r0.x, -r0, c3.z
cmp r0.x, r0, c4, c4.y
mov r1.xyw, -r3.yzxw
mov r1.z, -r3.w
mad r1, r1, c4.z, r3
add r3, r1, -r2
mov_sat r1.x, c2
mad r3, r1.x, r3, r2
add r4, -r2, c3.w
mad r1, r1.x, r4, r2
abs_pp r0.x, r0
cmp_pp r0, -r0.x, r3, r1
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}