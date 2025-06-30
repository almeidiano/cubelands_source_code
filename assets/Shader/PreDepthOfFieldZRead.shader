//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/PreDepthOfFieldZRead" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "" {}
 _onePixelTex ("Pixel (RGB)", 2D) = "" {}
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  ColorMask A
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
"!!ARBvp1.0
# 5 ALU
PARAM c[5] = { program.local[0],
		state.matrix.mvp };
MOV result.texcoord[0].xy, vertex.texcoord[0];
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
"vs_2_0
; 5 ALU
dcl_position0 v0
dcl_texcoord0 v1
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
Vector 0 [_ZBufferParams]
Float 1 [focalFalloff]
Float 2 [focalSize]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_onePixelTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 19 ALU, 2 TEX
PARAM c[5] = { program.local[0..2],
		{ 1, 0, 0.5 },
		{ 1, 0.0039215689, 1.53787e-005, 6.2273724e-009 } };
TEMP R0;
TEMP R1;
TEX R0, c[3].z, texture[1], 2D;
TEX R1.x, fragment.texcoord[0], texture[0], 2D;
DP4 R0.x, R0, c[4];
ADD_SAT R0.y, R0.x, -c[2].x;
ADD R0.z, -R0.x, R0.y;
MAD R0.y, R1.x, c[0].x, c[0];
RCP R0.w, R0.y;
ADD_SAT R1.x, R0, c[2];
ADD R0.y, -R0.x, R0.w;
ADD R1.x, -R0, R1;
SLT R0.x, R0, R0.w;
RCP R0.w, R1.x;
ABS R1.x, R0;
RCP R0.z, R0.z;
MUL R0.z, R0.y, R0;
MUL R0.x, R0.y, R0.w;
CMP R0.y, -R1.x, c[3], c[3].x;
CMP R0.x, -R0.y, R0.z, R0;
MUL_SAT result.color, R0.x, c[1].x;
END
# 19 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Float 1 [focalFalloff]
Float 2 [focalSize]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_onePixelTex] 2D
"ps_2_0
; 20 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.50000000, 0.00000000, 1.00000000, 0
def c4, 1.00000000, 0.00392157, 0.00001538, 0.00000001
dcl t0.xy
texld r1, t0, s0
mov r0.xy, c3.x
mad r1.x, r1, c0, c0.y
rcp r3.x, r1.x
texld r0, r0, s1
dp4 r0.x, r0, c4
add_sat r2.x, r0, -c2
add r2.x, -r0, r2
rcp r1.x, r2.x
add r2.x, r3, -r0
add_sat r4.x, r0, c2
add r4.x, -r0, r4
add r0.x, -r3, r0
cmp r0.x, r0, c3.y, c3.z
mul r1.x, r1, r2
rcp r3.x, r4.x
mul r2.x, r2, r3
abs_pp r0.x, r0
cmp_pp r0.x, -r0, r1, r2
mul_pp_sat r0.x, r0, c1
mov_pp r0, r0.x
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}