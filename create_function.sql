-- Функция для создания пользователя-администратора
CREATE OR REPLACE FUNCTION create_admin(
    p_username VARCHAR(100),
    p_password_hash VARCHAR(255),
    p_permissions JSONB
) RETURNS UUID AS $$
DECLARE
    new_user_id UUID;
BEGIN
    -- Создание нового пользователя
    INSERT INTO users (username, password_hash, role)
    VALUES (p_username, p_password_hash, 'Admin')
    RETURNING id INTO new_user_id;

    -- Создание записи в таблице администраторов
    INSERT INTO admins (id, permissions)
    VALUES (new_user_id, p_permissions);

    -- Логирование действия
    INSERT INTO user_logs (user_id, action)
    VALUES (new_user_id, 'Created admin user');

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;

-- Функция для создания пользователя-клиента
CREATE OR REPLACE FUNCTION create_client(
    p_username VARCHAR(100),
    p_password_hash VARCHAR(255),
    p_full_name VARCHAR(100),
    p_phone_number VARCHAR(15)
) RETURNS UUID AS $$
DECLARE
    new_user_id UUID;
BEGIN
    -- Создание нового пользователя
    INSERT INTO users (username, password_hash, role)
    VALUES (p_username, p_password_hash, 'Client')
    RETURNING id INTO new_user_id;

    -- Создание записи в таблице клиентов
    INSERT INTO clients (id, full_name, phone_number)
    VALUES (new_user_id, p_full_name, p_phone_number);

    -- Логирование действия
    INSERT INTO user_logs (user_id, action)
    VALUES (new_user_id, 'Created client user');

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;

-- Функция для создания пользователя-менеджера
CREATE OR REPLACE FUNCTION create_manager(
    p_username VARCHAR(100),
    p_password_hash VARCHAR(255),
    p_full_name VARCHAR(100),
    p_hire_date TIMESTAMP
) RETURNS UUID AS $$
DECLARE
    new_user_id UUID;
BEGIN
    -- Создание нового пользователя
    INSERT INTO users (username, password_hash, role)
    VALUES (p_username, p_password_hash, 'Manager')
    RETURNING id INTO new_user_id;

    -- Создание записи в таблице менеджеров
    INSERT INTO managers (id, full_name, hire_date)
    VALUES (new_user_id, p_full_name, p_hire_date);

    -- Логирование действия
    INSERT INTO user_logs (user_id, action)
    VALUES (new_user_id, 'Created manager user');

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;



-- Функция для логического удаления пользователя-администратора
CREATE OR REPLACE FUNCTION delete_admin(
    p_admin_id UUID
) RETURNS VOID AS $$
BEGIN
    -- Обновление поля is_deleted для пользователя
    UPDATE users
    SET is_deleted = TRUE
    WHERE id = p_admin_id;

    -- Логирование действия
    INSERT INTO user_logs (user_id, action)
    VALUES (p_admin_id, 'Logically deleted admin user');
END;
$$ LANGUAGE plpgsql;

-- Функция для логического удаления пользователя-менеджера
CREATE OR REPLACE FUNCTION delete_manager(
    p_manager_id UUID
) RETURNS VOID AS $$
BEGIN
    -- Обновление поля is_deleted для пользователя
    UPDATE users
    SET is_deleted = TRUE
    WHERE id = p_manager_id;

    -- Логирование действия
    INSERT INTO user_logs (user_id, action)
    VALUES (p_manager_id, 'Logically deleted manager user');
END;
$$ LANGUAGE plpgsql;

-- Функция для логического удаления пользователя-клиента
CREATE OR REPLACE FUNCTION delete_client(
    p_client_id UUID
) RETURNS VOID AS $$
BEGIN
    -- Обновление поля is_deleted для пользователя
    UPDATE users
    SET is_deleted = TRUE
    WHERE id = p_client_id;

    -- Логирование действия
    INSERT INTO user_logs (user_id, action)
    VALUES (p_client_id, 'Logically deleted client user');
END;
$$ LANGUAGE plpgsql;
