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
        Schema::disableForeignKeyConstraints();

        Schema::create('tbl_keluarga', function (Blueprint $table) {
            $table->integer('id_keluarga')->primary()->autoIncrement();
            $table->string('nama_keluarga', 160);
            $table->text('alamat_lengkap')->nullable();
            $table->integer('id_sektor')->nullable();
            $table->foreign('id_sektor')->references('id_sektor')->on('tbl_sektor');
            $table->integer('id_kepala_keluarga')->nullable();
            $table->foreign('id_kepala_keluarga')->references('id_jemaat')->on('tbl_jemaat');
            $table->enum('status_keluarga', ["Aktif","Pindah","Nonaktif"])->nullable();
            $table->timestamp('created_at')->nullable()->useCurrent();
            $table->timestamp('updated_at')->nullable()->useCurrent();
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tbl_keluarga');
    }
};
