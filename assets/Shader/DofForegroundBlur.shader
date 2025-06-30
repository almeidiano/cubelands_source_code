//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/DofForegroundBlur" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "" {}
 _SourceTex ("Source (RGB)", 2D) = "" {}
 _BlurredCoc ("COC (RGB)", 2D) = "" {}
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
Float 0 [foregroundBlurStrength]
Float 1 [foregroundBlurThreshhold]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BlurredCoc] 2D
SetTexture 3 [_SourceTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 4 TEX
PARAM c[4] = { program.local[0..1],
		{ 1, 0.0039215689, 1.53787e-005, 6.2273724e-009 },
		{ 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2, fragment.texcoord[0], texture[3], 2D;
TEX R1, fragment.texcoord[0], texture[1], 2D;
TEX R0.w, fragment.texcoord[0], texture[2], 2D;
TEX R0.x, fragment.texcoord[0], texture[0], 2D;
DP4 R0.y, R1, c[2];
ADD R0.y, R0, c[1].x;
MUL R0.z, R0.w, c[0].x;
ADD R0.x, R0, -R0.y;
CMP R0.x, -R0, R0.z, c[3];
MAX result.color.w, R0.x, R2;
MOV result.color.xyz, R2;
END
# 11 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Float 0 [foregroundBlurStrength]
Float 1 [foregroundBlurThreshhold]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BlurredCoc] 2D
SetTexture 3 [_SourceTex] 2D
"ps_2_0
; 7 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 1.00000000, 0.00392157, 0.00001538, 0.00000001
def c3, 0.00000000, 0, 0, 0
dcl t0.xy
texld r0, t0, s3
texld r3, t0, s0
texld r2, t0, s1
texld r1, t0, s2
dp4 r1.x, r2, c2
add r1.x, r1, c1
add r1.x, r3, -r1
mul r2.x, r1.w, c0
cmp_pp r1.x, -r1, c3, r2
max_pp r0.w, r1.x, r0
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}