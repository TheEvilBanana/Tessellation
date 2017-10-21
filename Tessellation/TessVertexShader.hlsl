cbuffer externalData : register(b0)
{
	matrix world;
	//matrix view;
	//matrix projection;
};

struct VertexIn
{
	float3 position		: POSITION;
	float2 uv			: TEXCOORD;
	float3 normal		: NORMAL;
	float3 tangent		: TANGENT;
};

struct VertexOut
{
	float3 normal		: NORMAL;
	float3 tangent		: TANGENT;
	float3 worldPos		: POSITION;
	float2 uv			: TEXCOORD;
};

VertexOut main(VertexIn input)
{
	VertexOut output;

	output.normal = mul(input.normal, (float3x3)world);
	output.tangent = mul(input.tangent, (float3x3)world);
	output.worldPos = mul(float4(input.position, 1.0f), world).xyz;
	output.uv = input.uv;

	return output;

}