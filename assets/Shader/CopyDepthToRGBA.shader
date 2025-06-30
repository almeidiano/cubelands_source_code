//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/CopyDepthToRGBA" {
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
Vector 5 [_CameraDepthTexture_ST]
"!!ARBvp1.0
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
Vector 4 [_MainTex_TexelSize]
Vector 5 [_CameraDepthTexture_ST]
"vs_2_0
; 14 ALU
def c6, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.x, c6
slt r0.x, c4.y, r0
max r0.x, -r0, r0
slt r0.z, c6.x, r0.x
mad r0.xy, v1, c5, c5.zwzw
add r0.w, -r0.z, c6.y
mul r0.w, r0.y, r0
add r0.y, -r0, c6
mad oT0.y, r0.z, r0, r0.w
mov oT0.x, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_CameraDepthTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 8 ALU, 1 TEX
PARAM c[2] = { { 1, 0, 0.99989998, 0.0039215689 },
		{ 1, 255, 65025, 1.6058138e+008 } };
TEMP R0;
TEMP R1;
TEX R0.x, fragment.texcoord[0], texture[0], 2D;
MUL R1, R0.x, c[1];
SLT R0.x, c[0].z, R0;
FRC R1, R1;
ABS R0.x, R0;
MAD R1, -R1.yzww, c[0].w, R1;
CMP R0.x, -R0, c[0].y, c[0];
CMP result.color, -R0.x, R1, c[0].x;
END
# 8 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_CameraDepthTexture] 2D
"ps_2_0
; 10 ALU, 1 TEX
dcl_2d s0
def c0, 0.99989998, 0.00000000, 1.00000000, 0.00392157
def c1, 1.00000000, 255.00000000, 65025.00000000, 160581376.00000000
dcl t0.xy
texld r0, t0, s0
mul r1, r0.x, c1
frc r1, r1
add r0.x, -r0, c0
cmp r0.x, r0, c0.y, c0.z
mov r2.z, -r1.w
mov r2.xyw, -r1.yzxw
mad r1, r2, c0.w, r1
abs_pp r0.x, r0
cmp_pp r0, -r0.x, r1, c0.z
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}