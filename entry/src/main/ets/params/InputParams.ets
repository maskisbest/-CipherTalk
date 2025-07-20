export interface InputParams {
    placeholder?: string
    value?: string
    icon?: Resource
    obscureText?: boolean
    inputWidth?: string | number
    onValueChange?: (value: string) => void
    togglePassword?: () => void  // 新增 togglePassword 属性
}