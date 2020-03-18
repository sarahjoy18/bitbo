<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class RBarangayZone
 * 
 * @property int $BARANGAY_ZONE_ID
 * @property string $BARANGAY_ZONE_NAME
 * @property string $BARANGAY_ZONE_DESC
 * @property int $BARANGAY_ID
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\RBarangayInformation $r_barangay_information
 * @property \Illuminate\Database\Eloquent\Collection $t_business_informations
 *
 * @package App\Models
 */
class RBarangayZone extends Eloquent
{
	protected $table = 'r_barangay_zone';
	protected $primaryKey = 'BARANGAY_ZONE_ID';
	public $timestamps = false;

	protected $casts = [
		'BARANGAY_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BARANGAY_ZONE_NAME',
		'BARANGAY_ZONE_DESC',
		'BARANGAY_ID',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function r_barangay_information()
	{
		return $this->belongsTo(\App\Models\RBarangayInformation::class, 'BARANGAY_ID');
	}

	public function t_business_informations()
	{
		return $this->hasMany(\App\Models\TBusinessInformation::class, 'BARANGAY_ZONE_ID');
	}
}
