export interface ResponseDao<T> {
    code: string;
    message: string;
    data: T;
}

export interface IUserDao {
    email: string;
    password: string;
    // 根据实际接口添加字段
}