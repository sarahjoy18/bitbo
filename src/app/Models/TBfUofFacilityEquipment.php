<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfUofFacilityEquipment
 * 
 * @property int $UOF_FACILITY_ID
 * @property int $FACILITY_ID
 * @property int $NO_OF_FACILITY
 * @property string $REMARKS
 * @property int $USE_OF_FACILITY_EQUIPMENT_ID
 * 
 * @property \App\Models\RBfFacilitiesEquipment $r_bf_facilities_equipment
 * @property \App\Models\TBfUseOfFacilityEquipment $t_bf_use_of_facility_equipment
 *
 * @package App\Models
 */
class TBfUofFacilityEquipment extends Eloquent
{
	protected $table = 't_bf_uof_facility_equipment';
	protected $primaryKey = 'UOF_FACILITY_ID';
	public $timestamps = false;

	protected $casts = [
		'FACILITY_ID' => 'int',
		'NO_OF_FACILITY' => 'int',
		'USE_OF_FACILITY_EQUIPMENT_ID' => 'int'
	];

	protected $fillable = [
		'FACILITY_ID',
		'NO_OF_FACILITY',
		'REMARKS',
		'USE_OF_FACILITY_EQUIPMENT_ID'
	];

	public function r_bf_facilities_equipment()
	{
		return $this->belongsTo(\App\Models\RBfFacilitiesEquipment::class, 'FACILITY_ID');
	}

	public function t_bf_use_of_facility_equipment()
	{
		return $this->belongsTo(\App\Models\TBfUseOfFacilityEquipment::class, 'USE_OF_FACILITY_EQUIPMENT_ID');
	}
}
