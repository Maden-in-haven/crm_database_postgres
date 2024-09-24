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

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;
