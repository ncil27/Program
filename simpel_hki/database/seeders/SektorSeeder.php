<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Sektor;

class SektorSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $sektors = ['Sektor 1', 'Sektor 2', 'Sektor 3', 'Sektor 4', 'Sektor 5', 'Sektor 6', 'Sektor 7', 'Sektor 8', 'Sektor 9', 'Sektor 10', 'Sektor 11', 'Sektor 12', 'Sektor 13'];

        $ket = ['Cidurian, Margahayu, Sentosa Asih', 'Jl. Logam, Ciwastra, Bodogol , GBA, GBI', 'Bumi Harapan, Panyileukan, Bodogo, Riung Bandung, Sapan', 'Cibiru, Cileunyi', 'Cileunyi, Tanjung Sari, Rancaekek, Cicalengka, Majalaya', 'Cibiru , Cilengkrang, Cisaranten, Ujung Berung, Cicaheum', 'Cicaheum, Cicadas, Jl. Suci, Jl. Riau, Sadang Serang, Dago', '-', 'Buah Batu, Moch. Toha, Baleendah, Ciparay, Banjaran, Cibaduyut', 'Alun-alun, Kopo, Immanuel, Cibolerang, TKI, Cigondewah, Cibaduyut', 'Rancamanyar, Margahayu Kencana, Soreang, Ciwidey', 'Alun-alun, Sudirman, Cijerah, Cimahi', 'Bandung'];

        foreach ($sektors as $index => $nama_sektor) {
            Sektor::create([
                'nama_sektor' => $nama_sektor,
                'keterangan' => $ket[$index],
            ]);
        }
    }
}
