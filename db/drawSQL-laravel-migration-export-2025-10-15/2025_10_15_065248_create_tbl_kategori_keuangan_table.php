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

        Schema::create('tbl_kategori_keuangan', function (Blueprint $table) {
            $table->integer('id_kategori')->primary()->autoIncrement();
            $table->string('nama_kategori', 100);
            $table->enum('jenis_kategori', ["Pemasukan","Pengeluaran"]);
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tbl_kategori_keuangan');
    }
};
