const UserDefinedMethodMap: Map<string, (args: Object) => void> = new Map();

class ApiCustomDialogManager {
  registerHandler(builder: (args: ESObject) => void) {
    UserDefinedMethodMap.set('customPermissionPrompt', builder)
    return;
  }

  getHandler() {
    return UserDefinedMethodMap.get('customPermissionPrompt')
  }
}

export const apiCustomDialogManager = new ApiCustomDialogManager()