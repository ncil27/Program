<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->integer('id_user')->primary()->autoIncrement();
            $table->string('username', 50)->unique();
            $table->string('password_hash', 255);
            $table->string('nama_lengkap', 255)->nullable();
            $table->enum('role', ["Admin","Tata Usaha"]);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
