#pragma once

#include <DirectXMath.h>

#include "DXCore.h"
#include "Camera.h"
#include "Mesh.h"
#include "Material.h"
#include "GameEntity.h"
#include "Render.h"
#include "Lights.h"

using namespace DirectX;

class Game : public DXCore
{
public:
	Game(HINSTANCE hInstance);
	~Game();

	// Overridden setup and game loop methods, which
	// will be called automatically
	void Init();
	void OnResize();
	void Update(float deltaTime, float totalTime);
	void Draw(float deltaTime, float totalTime);

	// Overridden mouse input helper methods
	void OnMouseDown(WPARAM buttonState, int x, int y);
	void OnMouseUp(WPARAM buttonState, int x, int y);
	void OnMouseMove(WPARAM buttonState, int x, int y);
	void OnMouseWheel(float wheelDelta, int x, int y);

private:

	// Initialization helper methods 
	void CameraInitialize();
	void ShadersInitialize();
	void ModelsInitialize();
	void LoadTextures();
	void MaterialsInitialize();
	void SkyBoxInitialize();
	void GameEntityInitialize();

	// Buffers to hold actual geometry data
	ID3D11Buffer* vertexBuffer;
	ID3D11Buffer* indexBuffer;

	ID3D11RasterizerState* rasterizer;

	//Declare shader variables
	SimpleVertexShader* baseVertexShader;
	SimplePixelShader* basePixelShader;
	SimpleVertexShader* skyVertexShader;
	SimplePixelShader* skyPixelShader;
	SimpleVertexShader* shadowVertexShader;

	//Tesselation
	SimpleVertexShader* tessVertexShader;
	SimpleHullShader* tessHullShader;
	SimpleDomainShader* tessDomainShader;
	SimplePixelShader* tessPixelShader;

	//Lights
	DirectionalLight dirLight_1;
	AmbientLight ambientLight;
	// Sampler for wrapping textures
	ID3D11SamplerState* sampler;
	ID3D11SamplerState* heightSampler;

	//Texture Shader Resource Views(SRVs)
	ID3D11ShaderResourceView* earthDayMapSRV;
	ID3D11ShaderResourceView* cobbleStoneSRV;
	ID3D11ShaderResourceView* snowRoughSRV;
	ID3D11ShaderResourceView* plainRedSRV;
	ID3D11ShaderResourceView* plainYellowSRV;
	ID3D11ShaderResourceView* stoneWallSRV;

	//Normal Shader Resource Views(SRVs)
	ID3D11ShaderResourceView* plainNormalMapSRV;
	ID3D11ShaderResourceView* earthNormalMapSRV;
	ID3D11ShaderResourceView* cobbleStoneNormalSRV;
	ID3D11ShaderResourceView* snowRoughNormalSRV;
	ID3D11ShaderResourceView* stoneWallNormalSRV;

	//Height map SRVs
	ID3D11ShaderResourceView* snowRoughHeightSRV;
	ID3D11ShaderResourceView* stoneWallHeightSRV;

	//Sky Box Stuff
	ID3D11ShaderResourceView* skySRV;
	ID3D11RasterizerState* skyRasterizerState;
	ID3D11DepthStencilState* skyDepthState;

	//Mesh Class
	Mesh* sphereMesh;
	Mesh* cubeMesh;
	Mesh* quadMesh;

	//Material Class
	Material* materialEarth;
	Material* materialCobbleStone;
	Material* materialRed;
	Material* materialYellow;
	Material* materialSkyBox;
	Material* materialSnowRough;
	Material* materialEmpty;
	Material* materialStoneWall;

	//Game Entity Class
	GameEntity* skyBoxEntity;
	GameEntity* quadEntity;
	GameEntity* quadEntity1;
	std::vector<GameEntity*> sphereEntities;
	std::vector<GameEntity*> flatEntities;

	//Render Class
	Render render;

	//Camera class
	Camera* camera;

	// The matrices to go from model space to screen space
	XMFLOAT4X4 worldMatrix;
	XMFLOAT4X4 viewMatrix;
	XMFLOAT4X4 projectionMatrix;

	// Keeps track of the old mouse position.  Useful for 
	// determining how far the mouse moved in a single frame.
	POINT prevMousePos;
	POINT currentMousePos;
	POINT difference;

};

