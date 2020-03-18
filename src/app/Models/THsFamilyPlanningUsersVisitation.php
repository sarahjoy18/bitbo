<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsFamilyPlanningUsersVisitation
 * 
 * @property int $VISITATION_ID
 * @property int $FP_ID
 * @property \Carbon\Carbon $VISITATION_DATE
 * @property string $VISITATION_REMARKS
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\THsFamilyPlanning $t_hs_family_planning
 *
 * @package App\Models
 */
class THsFamilyPlanningUsersVisitation extends Eloquent
{
	protected $primaryKey = 'VISITATION_ID';
	public $timestamps = false;

	protected $casts = [
		'FP_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'VISITATION_DATE',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'FP_ID',
		'VISITATION_DATE',
		'VISITATION_REMARKS',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_hs_family_planning()
	{
		return $this->belongsTo(\App\Models\THsFamilyPlanning::class, 'FP_ID');
	}
}
