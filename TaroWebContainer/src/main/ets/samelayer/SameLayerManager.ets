export const UserDefinedMethodMap: Map<string, (args: Object) => void> = new Map();

export class ApiCustomDialogManager {
    registerMethodsBuilder(builder: (args: ESObject) => void) {
      UserDefinedMethodMap.set('customPermissionPrompt', builder)
      return;
    }

    getBuild() {
      return UserDefinedMethodMap.get('customPermissionPrompt')
    }
}

export const apiCustomDialogManager = new ApiCustomDialogManager()