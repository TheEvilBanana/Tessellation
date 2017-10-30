cbuffer externalData : register(b0)
{
	//matrix world;
	matrix view;
	matrix projection;
};

Texture2D heightSRV : register(t0);

SamplerState basicSampler : register(s0);

struct DomainOut
{
	float4 vPosition	: SV_POSITION;
	float3 normal		: NORMAL;
	float3 tangent		: TANGENT;
	float3 worldPos		: POSITION;
	float2 uv			: TEXCOORD;
};

// Output control point
struct HullOut
{
	float3 normal		: NORMAL;
	float3 tangent		: TANGENT;
	float3 worldPos		: POSITION;
	float2 uv			: TEXCOORD;
};

// Output patch constant data.
struct HS_CONSTANT_DATA_OUTPUT
{
	float EdgeTessFactor[3]			: SV_TessFactor; // e.g. would be [4] for a quad domain
	float InsideTessFactor			: SV_InsideTessFactor; // e.g. would be Inside[2] for a quad domain
	// TODO: change/add other stuff
};

#define NUM_CONTROL_POINTS 3

[domain("tri")]
DomainOut main(
	HS_CONSTANT_DATA_OUTPUT input,
	float3 domain : SV_DomainLocation,
	const OutputPatch<HullOut, NUM_CONTROL_POINTS> patch)
{
	DomainOut Output;

	//Output.vPosition = float4(patch[0].vPosition*domain.x+patch[1].vPosition*domain.y+patch[2].vPosition*domain.z,1);
	Output.normal = domain.x*patch[0].normal + domain.y*patch[1].normal + domain.z*patch[2].normal;
	Output.tangent = domain.x*patch[0].tangent + domain.y*patch[1].tangent + domain.z*patch[2].tangent;
	Output.worldPos = domain.x*patch[0].worldPos + domain.y*patch[1].worldPos + domain.z*patch[2].worldPos;
	Output.uv = domain.x*patch[0].uv + domain.y*patch[1].uv + domain.z*patch[2].uv;

	Output.normal = normalize(Output.normal);

	//Height map calc
	/*float hScale = 1.0f;
	float hMap = heightSRV.SampleLevel(basicSampler, Output.uv, 0).r;
	Output.worldPos += ((hScale * (hMap - 1.0f)) * Output.normal);*/

	float hScale = 0.2f;
	float hBias = 0.0f;
	float3 vDir = -Output.normal;
	float hMap = heightSRV.SampleLevel(basicSampler, Output.uv, 0).r;
	hMap *= hScale;
	hMap += hBias;
	Output.worldPos += hMap * vDir;

	matrix viewProj = mul(view, projection);

	Output.vPosition = mul(float4(Output.worldPos, 1.0f), viewProj);


	return Output;
}
