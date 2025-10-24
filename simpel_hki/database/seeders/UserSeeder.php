<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'name' => 'Cecil Admin',
            'username' => 'cecil',
            'role' => 'admin',
            'email' => 'cecil@admin.com',
            'password' => bcrypt('password123'),]);
    }
}
