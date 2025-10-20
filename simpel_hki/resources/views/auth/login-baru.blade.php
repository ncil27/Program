<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - SIMPEL HKI DAME</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .login-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 420px;
            padding: 40px 35px;
        }

        .logo-container {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-container img {
            width: 200px;
            height: auto;
            margin-bottom: 10px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header h2 {
            color: #333;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .login-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: #374151;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #f9fafb;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            font-size: 14px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #374151;
        }

        .remember-me input[type="checkbox"] {
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .forgot-password {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        .btn-login {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .error-message {
            background-color: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            display: none;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 30px 25px;
            }

            .logo-container img {
                width: 160px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo-container">
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 500 400'%3E%3Crect x='83' y='150' width='45' height='50' fill='%230000FF'/%3E%3Crect x='159' y='150' width='45' height='50' fill='%230000FF'/%3E%3Crect x='83' y='220' width='45' height='130' fill='%230000FF'/%3E%3Crect x='159' y='220' width='45' height='130' fill='%230000FF'/%3E%3Ctext x='228' y='195' font-family='Arial, sans-serif' font-size='55' font-weight='bold' fill='%230000FF'%3ESIMPEL%3C/text%3E%3Ctext x='228' y='260' font-family='Arial, sans-serif' font-size='55' font-weight='bold' fill='%230000FF'%3EHKI%3C/text%3E%3Ctext x='228' y='345' font-family='Arial, sans-serif' font-size='60' font-weight='bold' fill='%230000FF'%3EDAME%3C/text%3E%3C/svg%3E" alt="SIMPEL HKI DAME Logo">
        </div>

        <div class="login-header">
            <h2>Admin Login</h2>
            <p>Silakan masuk ke akun admin Anda</p>
        </div>

        <x-auth-session-status class="mb-4" :status="session('status')" />

        @if ($errors->any())
            <div class="error-message" style="display: block;">
                {{ $errors->first() }}
            </div>
        @endif

        <form id="loginForm" method="POST" action="{{route('login')}}">
            @csrf
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="admin@example.com" required value="{{ old('email') }}">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>

            <div class="remember-forgot">
                <label class="remember-me">
                    <input type="checkbox" name="remember" id="remember">
                    <span>Ingat saya</span>
                </label>
                <a href="{{ route('password.request') }}" class="forgot-password">Lupa password?</a>
            </div>

            <button type="submit" class="btn-login">Masuk</button>
        </form>
    </div>

    <script>
        // Optional: Form validation atau handling
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            // e.preventDefault(); // Uncomment untuk testing
            
            // Contoh validasi sederhana
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            if (!email || !password) {
                e.preventDefault();
                document.getElementById('errorMessage').style.display = 'block';
                document.getElementById('errorMessage').textContent = 'Harap isi semua field!';
            }
        });
    </script>
</body>
</html>