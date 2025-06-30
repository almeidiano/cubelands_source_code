//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/PreDepthOfField" {
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
Vector 4 [_CameraDepthTexture_ST]
"vs_2_0
; 5 ALU
dcl_position0 v0
dcl_texcoord0 v1
mad oT0.xy, v1, c4, c4.zwzw
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
Float 1 [focalDistance01]
Float 2 [focalFalloff]
Float 3 [focalStart01]
Float 4 [focalEnd01]
SetTexture 0 [_CameraDepthTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 16 ALU, 1 TEX
PARAM c[6] = { program.local[0..4],
		{ 1, 0 } };
TEMP R0;
TEX R0.x, fragment.texcoord[0], texture[0], 2D;
MOV R0.y, c[1].x;
ADD R0.z, -R0.y, c[3].x;
MAD R0.x, R0, c[0], c[0].y;
RCP R0.w, R0.x;
RCP R0.x, R0.z;
ADD R0.z, R0.w, -c[1].x;
ADD R0.y, -R0, c[4].x;
SLT R0.w, c[1].x, R0;
RCP R0.y, R0.y;
MUL R0.x, R0.z, R0;
MUL R0.y, R0.z, R0;
ABS R0.w, R0;
CMP R0.z, -R0.w, c[5].y, c[5].x;
CMP R0.x, -R0.z, R0, R0.y;
MUL_SAT result.color, R0.x, c[2].x;
END
# 16 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Float 1 [focalDistance01]
Float 2 [focalFalloff]
Float 3 [focalStart01]
Float 4 [focalEnd01]
SetTexture 0 [_CameraDepthTexture] 2D
"ps_2_0
; 18 ALU, 1 TEX
dcl_2d s0
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
texld r0, t0, s0
mad r0.x, r0, c0, c0.y
rcp r1.x, r0.x
add r0.x, -r1, c1
cmp r0.x, r0, c5, c5.y
mov r2.x, c4
mov r3.x, c3
add r2.x, -c1, r2
add r3.x, -c1, r3
add r1.x, r1, -c1
rcp r2.x, r2.x
mul r2.x, r1, r2
rcp r3.x, r3.x
abs_pp r0.x, r0
mul r1.x, r3, r1
cmp_pp r0.x, -r0, r1, r2
mul_pp_sat r0.x, r0, c2
mov_pp r0, r0.x
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}