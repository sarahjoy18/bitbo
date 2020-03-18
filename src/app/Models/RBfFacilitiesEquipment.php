<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class RBfFacilitiesEquipment
 * 
 * @property int $FACILITY_EQUIPMENT_ID
 * @property string $FACILITY_EQUIPMENT_NAME
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_uof_facility_equipments
 *
 * @package App\Models
 */
class RBfFacilitiesEquipment extends Eloquent
{
	protected $table = 'r_bf_facilities_equipment';
	protected $primaryKey = 'FACILITY_EQUIPMENT_ID';
	public $timestamps = false;

	protected $fillable = [
		'FACILITY_EQUIPMENT_NAME'
	];

	public function t_bf_uof_facility_equipments()
	{
		return $this->hasMany(\App\Models\TBfUofFacilityEquipment::class, 'FACILITY_ID');
	}
}
