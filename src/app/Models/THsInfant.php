<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsInfant
 * 
 * @property int $INFANT_ID
 * @property int $NEW_BORN_ID
 * @property string $TYPE_OF_HOME_RECORD
 * @property \Carbon\Carbon $OPT_DATE
 * @property float $OPT_WEIGHT
 * @property float $OPT_HEIGHT
 * @property \Carbon\Carbon $GP_APRIL_VIT_A
 * @property \Carbon\Carbon $GP_OCTOBER_VIT_A
 * @property string $DANGERS_OBSERVED
 * @property string $SOURCE_OF_SERVICE_RECEIVED
 * @property int $HAD_BREASTFEED
 * @property int $HAD_PENTA_1
 * @property int $HAD_PENTA_2
 * @property int $HAD_PENTA_3
 * @property int $HAD_OPV_1
 * @property int $HAD_OPV_2
 * @property int $HAD_OPV_3
 * @property int $HAD_ROTA_1
 * @property int $HAD_ROTA_2
 * @property int $HAD_MEASLES
 * @property int $HAD_VITAMIN_A
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * @property int $DO_A
 * @property int $DO_B
 * @property int $DO_C
 * @property int $DO_D
 * @property int $DO_E
 * @property int $DO_F
 * @property int $DO_G
 * @property int $DO_H
 * 
 * @property \App\Models\THsNewborn $t_hs_newborn
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_children
 *
 * @package App\Models
 */
class THsInfant extends Eloquent
{
	protected $table = 't_hs_infant';
	protected $primaryKey = 'INFANT_ID';
	public $timestamps = false;

	protected $casts = [
		'NEW_BORN_ID' => 'int',
		'OPT_WEIGHT' => 'float',
		'OPT_HEIGHT' => 'float',
		'HAD_BREASTFEED' => 'int',
		'HAD_PENTA_1' => 'int',
		'HAD_PENTA_2' => 'int',
		'HAD_PENTA_3' => 'int',
		'HAD_OPV_1' => 'int',
		'HAD_OPV_2' => 'int',
		'HAD_OPV_3' => 'int',
		'HAD_ROTA_1' => 'int',
		'HAD_ROTA_2' => 'int',
		'HAD_MEASLES' => 'int',
		'HAD_VITAMIN_A' => 'int',
		'ACTIVE_FLAG' => 'int',
		'DO_A' => 'int',
		'DO_B' => 'int',
		'DO_C' => 'int',
		'DO_D' => 'int',
		'DO_E' => 'int',
		'DO_F' => 'int',
		'DO_G' => 'int',
		'DO_H' => 'int'
	];

	protected $dates = [
		'OPT_DATE',
		'GP_APRIL_VIT_A',
		'GP_OCTOBER_VIT_A',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'NEW_BORN_ID',
		'TYPE_OF_HOME_RECORD',
		'OPT_DATE',
		'OPT_WEIGHT',
		'OPT_HEIGHT',
		'GP_APRIL_VIT_A',
		'GP_OCTOBER_VIT_A',
		'DANGERS_OBSERVED',
		'SOURCE_OF_SERVICE_RECEIVED',
		'HAD_BREASTFEED',
		'HAD_PENTA_1',
		'HAD_PENTA_2',
		'HAD_PENTA_3',
		'HAD_OPV_1',
		'HAD_OPV_2',
		'HAD_OPV_3',
		'HAD_ROTA_1',
		'HAD_ROTA_2',
		'HAD_MEASLES',
		'HAD_VITAMIN_A',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG',
		'DO_A',
		'DO_B',
		'DO_C',
		'DO_D',
		'DO_E',
		'DO_F',
		'DO_G',
		'DO_H'
	];

	public function t_hs_newborn()
	{
		return $this->belongsTo(\App\Models\THsNewborn::class, 'NEW_BORN_ID');
	}

	public function t_hs_children()
	{
		return $this->hasMany(\App\Models\THsChild::class, 'INFANT_ID');
	}
}
