<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TPatawag
 * 
 * @property int $PATAWAG_ID
 * @property int $BLOTTER_ID
 * @property \Carbon\Carbon $PATAWAG_SCHED_DATETIME
 * @property string $PATAWAD_SCHED_PLACE
 * @property string $STATUS
 * @property int $ACTIVE_FLAG
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * 
 * @property \App\Models\TBlotter $t_blotter
 *
 * @package App\Models
 */
class TPatawag extends Eloquent
{
	protected $table = 't_patawag';
	protected $primaryKey = 'PATAWAG_ID';
	public $timestamps = false;

	protected $casts = [
		'BLOTTER_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'PATAWAG_SCHED_DATETIME',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BLOTTER_ID',
		'PATAWAG_SCHED_DATETIME',
		'PATAWAD_SCHED_PLACE',
		'STATUS',
		'ACTIVE_FLAG',
		'CREATED_AT',
		'UPDATED_AT'
	];

	public function t_blotter()
	{
		return $this->belongsTo(\App\Models\TBlotter::class, 'BLOTTER_ID');
	}
}
