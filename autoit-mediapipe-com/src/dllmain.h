#pragma once

#include "autoit_bridge.h"

class CMediapipeModule : public ATL::CAtlDllModuleT< CMediapipeModule >
{
public:
	DECLARE_LIBID(LIBID_mediapipeCOM)
	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_MEDIAPIPE, "{29090432-104c-c6cd-cd2b-9f2a43abd5b6}")
};

extern class CMediapipeModule _AtlModule;

STDAPI_(BOOL) DllActivateManifest(_In_opt_ LPCWSTR pManifest);
STDAPI_(BOOL) DllActivateActCtx(_In_opt_ PCACTCTXW pActCtx);
STDAPI_(BOOL) DllDeactivateActCtx();
