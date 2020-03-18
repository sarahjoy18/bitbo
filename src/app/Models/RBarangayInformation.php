<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class RBarangayInformation
 * 
 * @property int $BARANGAY_ID
 * @property string $BARANGAY_NAME
 * @property string $BARANGAY_SEAL
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * @property int $USER_ID
 * 
 * @property \Illuminate\Database\Eloquent\Collection $r_barangay_zones
 * @property \Illuminate\Database\Eloquent\Collection $t_barangay_officials
 * @property \Illuminate\Database\Eloquent\Collection $t_household_informations
 *
 * @package App\Models
 */
class RBarangayInformation extends Eloquent
{
	protected $table = 'r_barangay_information';
	protected $primaryKey = 'BARANGAY_ID';
	public $timestamps = false;

	protected $casts = [
		'ACTIVE_FLAG' => 'int',
		'USER_ID' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BARANGAY_NAME',
		'BARANGAY_SEAL',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG',
		'USER_ID'
	];

	public function r_barangay_zones()
	{
		return $this->hasMany(\App\Models\RBarangayZone::class, 'BARANGAY_ID');
	}

	public function t_barangay_officials()
	{
		return $this->hasMany(\App\Models\TBarangayOfficial::class, 'BARANGAY_ID');
	}

	public function t_household_informations()
	{
		return $this->hasMany(\App\Models\THouseholdInformation::class, 'BARANGAY_ID');
	}
}
