<?php

use App\Models\Counter;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    $value = Counter::sum('count');

    return view('welcome', ['value' => $value]);
});

Route::get('/db-check', function () {
    try {
        DB::connection()->getPdo();
        return "Connexion à la base de données réussie.";
    } catch (\Exception $e) {
        return "Erreur de connexion à la base de données : " . $e->getMessage();
    }
});
