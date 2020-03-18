<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBarangayOfficial
 * 
 * @property int $BARANGAY_OFFICIAL_ID
 * @property int $RESIDENT_ID
 * @property int $BARANGAY_ID
 * @property \Carbon\Carbon $START_TERM
 * @property \Carbon\Carbon $END_TERM
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\RBarangayInformation $r_barangay_information
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 * @property \Illuminate\Database\Eloquent\Collection $t_ordinances
 * @property \Illuminate\Database\Eloquent\Collection $t_users
 *
 * @package App\Models
 */
class TBarangayOfficial extends Eloquent
{
	protected $table = 't_barangay_official';
	protected $primaryKey = 'BARANGAY_OFFICIAL_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'BARANGAY_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'START_TERM',
		'END_TERM',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'BARANGAY_ID',
		'START_TERM',
		'END_TERM',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function r_barangay_information()
	{
		return $this->belongsTo(\App\Models\RBarangayInformation::class, 'BARANGAY_ID');
	}

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}

	public function t_ordinances()
	{
		return $this->hasMany(\App\Models\TOrdinance::class, 'BARANGAY_OFFICIAL_ID');
	}

	public function t_users()
	{
		return $this->hasMany(\App\Models\TUser::class, 'BARANGAY_OFFICIAL_ID');
	}
}
