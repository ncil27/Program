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

        Schema::create('tbl_jemaat', function (Blueprint $table) {
            $table->integer('id_jemaat')->primary()->autoIncrement();
            $table->string('nik', 50)->unique()->nullable();
            $table->string('nama_lengkap', 255);
            $table->enum('jenis_kelamin', ["Laki-laki","Perempuan"]);
            $table->string('tempat_lahir', 100)->nullable();
            $table->date('tanggal_lahir')->nullable();
            $table->string('no_telepon', 25)->nullable();
            $table->integer('id_keluarga')->nullable();
            $table->foreign('id_keluarga')->references('id_keluarga')->on('tbl_keluarga');
            $table->string('pekerjaan', 100)->nullable();
            $table->string('pendidikan_terakhir', 100)->nullable();
            $table->enum('hubungan_keluarga', ["Kepala Keluarga","Istri","Anak","Lainnya"]);
            $table->enum('status_pernikahan', ["Belum Menikah","Menikah","Janda\/Duda"])->nullable();
            $table->enum('status_keanggotaan', ["Aktif","Pindah","Meninggal","Nonaktif"])->nullable();
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
        Schema::dropIfExists('tbl_jemaat');
    }
};
