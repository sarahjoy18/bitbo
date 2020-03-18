<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class RBlotterSubject
 * 
 * @property int $BLOTTER_ID
 * @property string $BLOTTER_NAME
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_blotters
 *
 * @package App\Models
 */
class RBlotterSubject extends Eloquent
{
	protected $primaryKey = 'BLOTTER_ID';
	public $timestamps = false;

	protected $casts = [
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BLOTTER_NAME',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_blotters()
	{
		return $this->hasMany(\App\Models\TBlotter::class, 'BLOTTER_SUBJECT');
	}
}
