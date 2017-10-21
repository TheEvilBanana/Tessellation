
struct DirectionalLight {
	float4 diffuseColor;
	//------------------------ 16 bytes
	float3 direction;
	float pad;
	//------------------------

};

Texture2D textureSRV : register(t0);
Texture2D normalMapSRV : register(t1);

SamplerState basicSampler : register(s0);

cbuffer ExternalData : register(b0) {
	DirectionalLight dirLight_1;
	float3 cameraPosition;
};

struct DomainOut
{
	float4 vPosition	: SV_POSITION;
	float3 normal		: NORMAL;
	float3 tangent		: TANGENT;
	float3 worldPos		: POSITION;
	float2 uv			: TEXCOORD;
};

void ComputeDirectionalLight(DomainOut input, DirectionalLight dirLight, float4 surfaceColor, out float4 diffuse)
{
	float lightAmountDL = saturate(dot(input.normal, -normalize(dirLight.direction)));
	float4 directionalL = dirLight_1.diffuseColor * lightAmountDL * surfaceColor;

	diffuse = directionalL;
}

float4 main(DomainOut input) : SV_TARGET
{
	input.normal = normalize(input.normal);
	input.tangent = normalize(input.tangent);

	float4 D = float4(0.0f, 0.0f, 0.0f, 0.0f);
	
	// Read and unpack normal from map
	float3 normalFromMap = normalMapSRV.Sample(basicSampler, input.uv).xyz * 2 - 1;

	// Transform from tangent to world space
	float3 N = input.normal;
	float3 T = normalize(input.tangent - N * dot(input.tangent, N));
	float3 B = cross(T, N);

	float3x3 TBN = float3x3(T, B, N);
	input.normal = normalize(mul(normalFromMap, TBN));

	float4 surfaceColor = textureSRV.Sample(basicSampler, input.uv);
	float4 diffuse = float4(0.0f, 0.0f, 0.0f, 0.0f);

	ComputeDirectionalLight(input, dirLight_1, surfaceColor, D);
	diffuse += D;

	return diffuse;
}